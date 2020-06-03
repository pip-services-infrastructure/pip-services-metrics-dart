import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/MetricDefinitionV1.dart';
import '../data/version1/MetricUpdateV1.dart';
import '../data/version1/MetricValueSetV1.dart';
import '../data/version1/MetricValueV1.dart';
import '../persistence/IMetricsPersistence.dart';
import '../persistence/TimeHorizonConverter.dart';
import '../persistence/TimeIndexComposer.dart';
import '../persistence/TimeParser.dart';

import './MetricsCommandSet.dart';
import './IMetricsController.dart';

class MetricsController
    implements ICommandable, IMetricsController, IConfigurable, IReferenceable {
  final ConfigParams _defaultConfig = ConfigParams.fromTuples(
      ['dependencies.persistence', 'pip-services-metrics:persistence:*:*:1.0']);

  IMetricsPersistence _persistence;
  MetricsCommandSet _commandSet;
  DependencyResolver _dependencyResolver;

  MetricsController() {
    _dependencyResolver = DependencyResolver(_defaultConfig);
  }

  @override
  void configure(ConfigParams config) {
    _dependencyResolver.configure(config);
  }

  @override
  void setReferences(IReferences references) {
    _dependencyResolver.setReferences(references);

    _persistence =
        _dependencyResolver.getOneRequired<IMetricsPersistence>('persistence');
  }

  @override
  CommandSet getCommandSet() {
    _commandSet ??= MetricsCommandSet(this);
    return _commandSet;
  }

  Future<List<MetricDefinitionV1>> _getMetricDefinitionsWithName(
      String correlationId, String name) async {
    var filter = FilterParams.fromTuples(['name', name, 'time_horizon', 0]);

    var take = 500;
    var paging = PagingParams(0, take);

    var definitions = {};
    var reading = true;

    for (; reading;) {
      var page =
          await _persistence.getPageByFilter(correlationId, filter, paging);

      for (var record in page.data) {
        MetricDefinitionV1 definition = definitions[record.name];
        if (definition == null) {
          definition = MetricDefinitionV1();

          definition.name = record.name;
          definition.dimension1 = <String>[];
          definition.dimension2 = <String>[];
          definition.dimension3 = <String>[];

          definitions[record.name] = definition;
        }

        if (record.d1 != null && !definition.dimension1.contains(record.d1)) {
          definition.dimension1.add(record.d1);
        }
        if (record.d2 != null && !definition.dimension2.contains(record.d2)) {
          definition.dimension2.add(record.d2);
        }
        if (record.d3 != null && !definition.dimension3.contains(record.d3)) {
          definition.dimension3.add(record.d3);
        }
      }

      if (page.data.isNotEmpty) {
        paging.skip += take;
      } else {
        reading = false;
      }
    }

    return List<MetricDefinitionV1>.from(definitions.values);
  }

  @override
  Future<List<MetricDefinitionV1>> getMetricDefinitions(String correlationId) {
    return _getMetricDefinitionsWithName(correlationId, null);
  }

  @override
  Future<MetricDefinitionV1> getMetricDefinitionByName(
      String correlationId, String name) async {
    var items = await _getMetricDefinitionsWithName(correlationId, name);

    return items.isNotEmpty ? items[0] : null;
  }

  @override
  Future<DataPage<MetricValueSetV1>> getMetricsByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    var page =
        await _persistence.getPageByFilter(correlationId, filter, paging);

    var timeHorizon = TimeHorizonConverter.fromString(
        filter.getAsNullableString('time_horizon'));
    var fromIndex =
        TimeIndexComposer.composeFromIndexFromFilter(timeHorizon, filter);
    var toIndex =
        TimeIndexComposer.composeToIndexFromFilter(timeHorizon, filter);

    // Convert records into value sets
    var sets = {};

    for (var record in page.data) {
      // Generate index
      var id = record.name +
          '_' +
          (record.d1 ?? '') +
          '_' +
          (record.d2 ?? '') +
          '_' +
          (record.d3 ?? '');

      // Get or create value set
      MetricValueSetV1 set = sets[id];
      if (set == null) {
        set = MetricValueSetV1()
          ..name = record.name
          ..time_horizon = record.th
          ..dimension1 = record.d1
          ..dimension2 = record.d2
          ..dimension3 = record.d3
          ..values = <MetricValueV1>[];

        sets[id] = set;
      }

      for (var key in record.val.keys) {
        if (key.compareTo(fromIndex) < 0 || key.compareTo(toIndex) > 0) {
          continue;
        }

        var value = MetricValueV1();
        TimeParser.parseTime(key, timeHorizon, value);
        value.count = record.val[key].cnt;
        value.sum = record.val[key].sum;
        value.min = record.val[key].min;
        value.max = record.val[key].max;

        set.values.add(value);
      }
      ;
    }

    var total = page.total;
    var values = List<MetricValueSetV1>.from(sets.values);

    return DataPage<MetricValueSetV1>(values, total);
  }

  @override
  Future updateMetric(
      String correlationId, MetricUpdateV1 update, int maxTimeHorizon) {
    return _persistence.updateOne(correlationId, update, maxTimeHorizon);
  }

  @override
  Future updateMetrics(
      String correlationId, List<MetricUpdateV1> updates, int maxTimeHorizon) {
    return _persistence.updateMany(correlationId, updates, maxTimeHorizon);
  }
}
