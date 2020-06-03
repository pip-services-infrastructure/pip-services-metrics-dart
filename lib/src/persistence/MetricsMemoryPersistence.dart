import 'dart:async';
import 'dart:math';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';

import '../data/version1/MetricUpdateV1.dart';
import '../data/version1/TimeHorizonV1.dart';
import './MetricRecord.dart';
import './MetricRecordValue.dart';
import './TimeRangeComposer.dart';
import './TimeIndexComposer.dart';
import './TimeHorizonConverter.dart';
import './MetricRecordIdComposer.dart';
import './IMetricsPersistence.dart';

class MetricsMemoryPersistence
    extends IdentifiableMemoryPersistence<MetricRecord, String>
    implements IReconfigurable, IMetricsPersistence {
  final _TimeHorizons = [
    TimeHorizonV1.Total,
    TimeHorizonV1.Year,
    TimeHorizonV1.Month,
    TimeHorizonV1.Day,
    TimeHorizonV1.Hour,
    TimeHorizonV1.Minute
  ];

  @override
  var maxPageSize = 1000;

  MetricsMemoryPersistence() : super();

  @override
  void configure(ConfigParams config) {
    maxPageSize = config.getAsIntegerWithDefault('max_page_size', maxPageSize);
  }

  dynamic _composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var name = filter.getAsNullableString('name');

    var names = filter.getAsObject('names');
    if (names is String) {
      names = names.split(',');
    }

    var timeHorizon = TimeHorizonConverter.fromString(
        filter.getAsNullableString('time_horizon'));
    var fromRange =
        TimeRangeComposer.composeFromRangeFromFilter(timeHorizon, filter);
    var toRange =
        TimeRangeComposer.composeToRangeFromFilter(timeHorizon, filter);
    var dimension1 = filter.getAsNullableString('dimension1');
    if (dimension1 == '*') dimension1 = null;
    var dimension2 = filter.getAsNullableString('dimension2');
    if (dimension2 == '*') dimension2 = null;
    var dimension3 = filter.getAsNullableString('dimension3');
    if (dimension3 == '*') dimension3 = null;

    return (item) {
      if (name != null && item.name != name) {
        return false;
      }
      if (names != null && names.indexOf(item.name) < 0) {
        return false;
      }
      if (item.th != timeHorizon) {
        return false;
      }
      if (fromRange != TimeHorizonV1.Total && item.rng < fromRange) {
        return false;
      }
      if (toRange != TimeHorizonV1.Total && item.rng > toRange) {
        return false;
      }
      if (dimension1 != null && item.d1 != dimension1) {
        return false;
      }
      if (dimension2 != null && item.d2 != dimension2) {
        return false;
      }
      if (dimension3 != null && item.d3 != dimension3) {
        return false;
      }
      return true;
    };
  }

  @override
  Future<DataPage<MetricRecord>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return await super
        .getPageByFilterEx(correlationId, _composeFilter(filter), paging, null);
  }

  @override
  Future updateOne(
      String correlationId, MetricUpdateV1 update, int maxTimeHorizon) async {
    for (var timeHorizon in _TimeHorizons) {
      if (timeHorizon > maxTimeHorizon) {
        continue;
      }

      var id = MetricRecordIdComposer.composeIdFromUpdate(timeHorizon, update);
      var range = TimeRangeComposer.composeRangeFromUpdate(timeHorizon, update);
      var index = items.indexWhere((item) => item.id == id);

      var timeIndex =
          TimeIndexComposer.composeIndexFromUpdate(timeHorizon, update);

      var item = MetricRecord();
      if (index < 0) {
        item.id = id;
        item.name = update.name;
        item.th = timeHorizon;
        item.rng = range;
        item.d1 = update.dimension1;
        item.d2 = update.dimension2;
        item.d3 = update.dimension3;
        item.val = <String, MetricRecordValue>{};

        items.add(item);
      } else {
        item = items[index];
      }

      var value = item.val[timeIndex];
      if (value == null) {
        value = MetricRecordValue();
        value.cnt = 0;
        value.sum = 0;
        value.min = update.value;
        value.max = update.value;

        item.val[timeIndex] = value;
      }

      value.cnt += 1;
      value.sum += update.value;
      value.min = min(value.min, update.value);
      value.max = max(value.max, update.value);
    }

    //this._logger.trace(correlationId, 'Updated metric');

    await save(correlationId);
  }

  @override
  Future updateMany(String correlationId, List<MetricUpdateV1> updates,
      int maxTimeHorizon) async {
    var count = 0;

    for (var update in updates) {
      await updateOne(correlationId, update, maxTimeHorizon);
      count++;
    }

    logger.trace(correlationId, r'Updated $n metrics', [count]);
  }

  /// correlationId String
  /// filter FilterParams
  @override
  Future deleteByFilter(String correlationId, FilterParams filter) {
    return super.deleteByFilterEx(correlationId, _composeFilter(filter));
  }
}
