import 'package:test/test.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import './MetricsPersistenceFixture.dart';

void main() {
  group('MetricsMemoryPersistence', () {
    MetricsMemoryPersistence persistence;
    MetricsPersistenceFixture fixture;

    setUp(() async {
      persistence = MetricsMemoryPersistence();
      persistence.configure(ConfigParams());

      fixture = MetricsPersistenceFixture(persistence);

      await persistence.open(
        null,
      );
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Simple Metrics', () async {
      await fixture.testSimpleMetrics();
    });

    test('Metric With Dimensions', () async {
      await fixture.testMetricWithDimensions();
    });

    test('Get Multiple Metrics', () async {
      await fixture.testGetMultipleMetrics();
    });
  });
}
