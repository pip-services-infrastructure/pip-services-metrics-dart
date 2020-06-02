import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_metrics/pip_services_metrics.dart';

void main() {
  group('MetricsHttpServiceV1', () {
    MetricsMemoryPersistence persistence;
    MetricsController controller;
    MetricsHttpServiceV1 service;
    http.Client rest;
    var url = 'http://localhost:3000';

    setUp(() async {
      rest = http.Client();

      persistence = MetricsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = MetricsController();
      controller.configure(ConfigParams());

      service = MetricsHttpServiceV1();
      service.configure(ConfigParams.fromTuples([
        'connection.protocol',
        'http',
        'connection.port',
        3000,
        'connection.host',
        'localhost'
      ]));

      var references = References.fromTuples([
        Descriptor(
            'pip-services-metrics', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor(
            'pip-services-metrics', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor('pip-services-metrics', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);

      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('TestMetrics', () async {
      // Update metric once

     var responce =  await rest.post(url + '/v1/metrics/update_metric',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'update': MetricUpdateV1()
              ..name = 'metric1'
              ..dimension1 = 'A'
              ..dimension2 = 'B'
              ..dimension3 = null
              ..year = 2018
              ..month = 8
              ..day = 26
              ..hour = 12
              ..value = 123,
            'max_time_horizon': TimeHorizonV1.Hour
          }));

      // Update metric second time

      responce = await rest.post(url + '/v1/metrics/update_metrics',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'updates': [
              MetricUpdateV1()
                ..name = 'metric1'
                ..dimension1 = 'A'
                ..dimension2 = 'B'
                ..dimension3 = null
                ..year = 2018
                ..month = 8
                ..day = 26
                ..hour = 13
                ..value = 321
            ],
            'max_time_horizon': TimeHorizonV1.Hour
          }));

      // Get total metric

      responce = await rest.post(url + '/v1/metrics/get_metrics_by_filter',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'filter': FilterParams.fromTuples(['name', 'metric1']),
            'paging': PagingParams()
          }));
      var page = DataPage<MetricValueSetV1>.fromJson(json.decode(responce.body),
          (item) => MetricValueSetV1.fromJson(item));

      expect(page, isNotNull);
      expect(1, page.data.length);
      MetricValueSetV1 set;
      set = page.data[0];
      expect('metric1', set.name);
      expect(TimeHorizonV1.Total, set.time_horizon);
      expect('A', set.dimension1);
      expect('B', set.dimension2);
      expect(set.dimension3, isNull);
      expect(1, set.values.length);
      var value = set.values[0];
      expect(444, value.sum);
      expect(123, value.min);
      expect(321, value.max);
      expect(2, value.count);

      // Get hour metric

      responce = await rest.post(url + '/v1/metrics/get_metrics_by_filter',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'filter': FilterParams.fromTuples([
              'name',
              'metric1',
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
            'paging': PagingParams()
          }));
      page = DataPage<MetricValueSetV1>.fromJson(json.decode(responce.body),
          (item) => MetricValueSetV1.fromJson(item));

      expect(1, page.data.length);
      set = page.data[0];
      expect('metric1', set.name);
      expect(TimeHorizonV1.Hour, set.time_horizon);
      expect('A', set.dimension1);
      expect('B', set.dimension2);
      expect(set.dimension3, isNull);

      expect(2, set.values.length);
      value = set.values[0];
      expect(2018, value.year);
      expect(8, value.month);
      expect(26, value.day);
      expect(12, value.hour);
      expect(123, value.sum);
      expect(123, value.min);
      expect(123, value.max);
      expect(1, value.count);

      value = set.values[1];
      expect(2018, value.year);
      expect(8, value.month);
      expect(26, value.day);
      expect(13, value.hour);
      expect(321, value.sum);
      expect(321, value.min);
      expect(321, value.max);
      expect(1, value.count);
    });

    test('TestDefinitions', () async {
      // Update metric once

      var metric1 = MetricUpdateV1();

      metric1.name = 'metric2';
      metric1.dimension1 = 'A';
      metric1.dimension2 = 'B';
      metric1.dimension3 = null;
      metric1.year = 2018;
      metric1.month = 8;
      metric1.day = 26;
      metric1.hour = 12;
      metric1.value = 123;

      var metric2 = MetricUpdateV1();

      metric2.name = 'metric2';
      metric2.dimension1 = 'A';
      metric2.dimension2 = 'C';
      metric2.dimension3 = null;
      metric2.year = 2018;
      metric2.month = 8;
      metric2.day = 26;
      metric2.hour = 13;
      metric2.value = 321;

      var updateMetrics = <MetricUpdateV1>[];
      updateMetrics.add(metric1);
      updateMetrics.add(metric2);

      // Update metric second time
      //controller.updateMetrics(null, updateMetrics, TimeHorizonV1.Hour);

      await rest.post(url + '/v1/metrics/update_metrics',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'updates': [
              MetricUpdateV1()
                ..name = 'metric2'
                ..dimension1 = 'A'
                ..dimension2 = 'B'
                ..dimension3 = null
                ..year = 2018
                ..month = 8
                ..day = 26
                ..hour = 12
                ..value = 123,
              MetricUpdateV1()
                ..name = 'metric2'
                ..dimension1 = 'A'
                ..dimension2 = 'C'
                ..dimension3 = null
                ..year = 2018
                ..month = 8
                ..day = 26
                ..hour = 13
                ..value = 321
            ],
            'max_time_horizon': TimeHorizonV1.Hour
          }));

      // Get all definitions

      var responce =
          await rest.post(url + '/v1/metrics/get_metric_definitions');
      var items = json.decode(responce.body).map((item)=>MetricDefinitionV1.fromJson(item));
      var definitions =
          List<MetricDefinitionV1>.from(items);
      expect(1, definitions.length);
      MetricDefinitionV1 definition;
      definition = definitions[0];
      expect('metric2', definition.name);
      expect(1, definition.dimension1.length);
      expect('A', definition.dimension1[0]);
      expect(2, definition.dimension2.length);
      expect('B', definition.dimension2[0]);
      expect('C', definition.dimension2[1]);
      expect(definition.dimension3, isEmpty);

      // Get a single definition
      responce =
          await rest.post(url + '/v1/metrics/get_metric_definition_by_name');
      definition = MetricDefinitionV1.fromJson(json.decode(responce.body));
      expect('metric2', definition.name);
    });
  });
}
