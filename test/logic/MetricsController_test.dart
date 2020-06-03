import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';

void main() {
  group('MetricsControllerTest', () {
    MetricsMemoryPersistence persistence;
    MetricsController controller;

    setUp(() async {
      persistence = MetricsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = MetricsController();
      controller.configure(ConfigParams());

      var references = References.fromTuples([
        Descriptor(
            'pip-services-metrics', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor(
            'pip-services-metrics', 'controller', 'default', 'default', '1.0'),
        controller
      ]);

      controller.setReferences(references);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('TestMetrics', () async {
      // Update metric once

      await controller.updateMetric(
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

      // Update metric second time

      await controller.updateMetrics(
          null,
          [
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
          TimeHorizonV1.Hour);

      // Get total metric

      var page = await controller.getMetricsByFilter(
          null, FilterParams.fromTuples(['name', 'metric1']), PagingParams());

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

      page = await controller.getMetricsByFilter(
          null,
          FilterParams.fromTuples([
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
          PagingParams());

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

      // Update metric second time
      await controller.updateMetrics(
          null,
          [
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
          TimeHorizonV1.Hour);

      // Get all definitions
      var definitions = await controller.getMetricDefinitions(null);

      expect(1, definitions.length);

      var definition = definitions[0];
      expect('metric2', definition.name);
      expect(1, definition.dimension1.length);
      expect('A', definition.dimension1[0]);
      expect(2, definition.dimension2.length);
      expect('B', definition.dimension2[0]);
      expect('C', definition.dimension2[1]);
      expect(definition.dimension3, isEmpty);

      // Get a single definition
      definition = await controller.getMetricDefinitionByName(null, 'metric2');
      expect('metric2', definition.name);
    });
  });
}
