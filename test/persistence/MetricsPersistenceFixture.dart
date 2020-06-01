import 'dart:async';
import 'package:test/test.dart';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';

class MetricsPersistenceFixture {
  IMetricsPersistence _persistence;

  MetricsPersistenceFixture(IMetricsPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void testSimpleMetrics() async {
    // Update metric once
    await _persistence.updateOne(
        null,
        MetricUpdateV1()
          ..name = 'metric2'
          ..year = 2018
          ..month = 8
          ..day = 26
          ..hour = 12
          ..value = 123,
        TimeHorizonV1.Hour);

    // Update metric second time
    await _persistence.updateMany(
        null,
        [
          MetricUpdateV1()
            ..name = 'metric2'
            ..year = 2018
            ..month = 8
            ..day = 26
            ..hour = 13
            ..value = 321
        ],
        TimeHorizonV1.Hour);

    // Get total metric
    var page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples(['name', 'metric2', 'time_horizon', 'total']),
        PagingParams());

    expect(page, isNotNull);
    expect(1, page.data.length);
    var record = page.data[0];
    expect(444, record.val['total'].sum);
    expect(123, record.val['total'].min);
    expect(321, record.val['total'].max);
    expect(2, record.val['total'].cnt);

    // Get year metric
    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric2',
          'time_horizon',
          'year',
          'from_year',
          2018,
          'to_year',
          2018
        ]),
        PagingParams());

    record = page.data[0];
    expect(444, record.val['2018'].sum);
    expect(123, record.val['2018'].min);
    expect(321, record.val['2018'].max);
    expect(2, record.val['2018'].cnt);

    // Get month metric
    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric2',
          'time_horizon',
          'month',
          'from_year',
          2018,
          'from_month',
          8,
          'to_year',
          2018,
          'to_month',
          8
        ]),
        PagingParams());

    expect(1, page.data.length);
    record = page.data[0];
    expect(444, record.val['201808'].sum);
    expect(123, record.val['201808'].min);
    expect(321, record.val['201808'].max);
    expect(2, record.val['201808'].cnt);

    // Get day metric
    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric2',
          'time_horizon',
          'day',
          'from_year',
          2018,
          'from_month',
          8,
          'from_day',
          26,
          'to_year',
          2018,
          'to_month',
          8,
          'to_day',
          26
        ]),
        PagingParams());
    expect(1, page.data.length);
    record = page.data[0];
    expect(444, record.val['20180826'].sum);
    expect(123, record.val['20180826'].min);
    expect(321, record.val['20180826'].max);
    expect(2, record.val['20180826'].cnt);

    // Get hour metric
    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric2',
          'time_horizon',
          'hour',
          'from_year',
          2018,
          'from_month',
          8,
          'from_day',
          26,
          'from_hour',
          0,
          'to_year',
          2018,
          'to_month',
          8,
          'to_day',
          26,
          'to_hour',
          23
        ]),
        PagingParams());
    expect(1, page.data.length);
    record = page.data[0];
    expect(123, record.val['2018082612'].sum);
    expect(123, record.val['2018082612'].min);
    expect(123, record.val['2018082612'].max);
    expect(1, record.val['2018082612'].cnt);

    expect(321, record.val['2018082613'].sum);
    expect(321, record.val['2018082613'].min);
    expect(321, record.val['2018082613'].max);
    expect(1, record.val['2018082613'].cnt);
  }

  void testMetricWithDimensions() async {
    await _persistence.updateOne(
        null,
        MetricUpdateV1()
          ..name = 'metric1'
          ..dimension1 = 'A'
          ..dimension2 = 'B'
          ..dimension3 = null
          ..year = 2018
          ..month = 8
          ..day = 26
          ..hour = 12
          ..value = 123,
        TimeHorizonV1.Hour);

    await _persistence.updateMany(
        null,
        [
          MetricUpdateV1()
            ..name = 'metric1'
            ..dimension1 = 'A'
            ..dimension2 = 'C'
            ..dimension3 = null
            ..year = 2018
            ..month = 8
            ..day = 26
            ..hour = 12
            ..value = 321
        ],
        TimeHorizonV1.Hour);

    var page = await _persistence.getPageByFilter(
        null, FilterParams.fromTuples(['name', 'metric1']), PagingParams());

    expect(page, isNotNull);
    expect(2, page.data.length);

    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples(['name', 'metric1', 'dimension1', 'A']),
        PagingParams());

    expect(page, isNotNull);
    expect(2, page.data.length);

    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples(
            ['name', 'metric1', 'dimension1', 'A', 'dimension2', 'B']),
        PagingParams());

    expect(page, isNotNull);
    expect(1, page.data.length);

    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric1',
          'dimension1',
          null,
          'dimension2',
          null,
          'dimension3',
          null
        ]),
        PagingParams());

    expect(page, isNotNull);
    expect(2, page.data.length);

    page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples([
          'name',
          'metric1',
          'dimension1',
          'na',
          'dimension2',
          'na',
          'dimension3',
          'na'
        ]),
        PagingParams());

    expect(page, isNotNull);
    expect(page.data, isEmpty);
  }

  void testGetMultipleMetrics() async {
    // Update metrics
    await _persistence.updateMany(
        null,
        [
          MetricUpdateV1()
            ..name = 'metric.1'
            ..year = 2018
            ..month = 1
            ..day = 1
            ..hour = 1
            ..value = 123,
          MetricUpdateV1()
            ..name = 'metric.2'
            ..year = 2018
            ..month = 2
            ..day = 2
            ..hour = 2
            ..value = 456,
          MetricUpdateV1()
            ..name = 'metric.3'
            ..year = 2018
            ..month = 3
            ..day = 3
            ..hour = 3
            ..value = 789
        ],
        TimeHorizonV1.Hour);

    // Delay, because update many can be async
    await Future.delayed(Duration(milliseconds: 1000));

    // Get total metric
    var page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromTuples(['names', 'metric.1,metric.2']),
        PagingParams());

    expect(page, isNotNull);
    expect(2, page.data.length);
  }
}
