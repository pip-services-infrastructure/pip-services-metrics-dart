import 'dart:io';
import 'package:test/test.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import './MetricsPersistenceFixture.dart';

void main() {
  group('MetricsMongoDbPersistence', () {
    MetricsMongoDbPersistence persistence;
    MetricsPersistenceFixture fixture;

    var mongoUri = Platform.environment['MONGO_SERVICE_URI'];
    var mongoHost = Platform.environment['MONGO_SERVICE_HOST'] ?? 'localhost';
    var mongoPort = Platform.environment['MONGO_SERVICE_PORT'] ?? 27017;
    var mongoDatabase = Platform.environment['MONGO_SERVICE_DB'] ?? 'test';

    // Exit if mongo connection is not set
    if (mongoUri == '' && mongoHost == '') {
      return;
    }

    setUp(() async {
      persistence = MetricsMongoDbPersistence();
      persistence.configure(ConfigParams.fromTuples([
        'connection.uri',
        mongoUri,
        'connection.host',
        mongoHost,
        'connection.port',
        mongoPort,
        'connection.database',
        mongoDatabase
      ]));

      fixture = MetricsPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
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
