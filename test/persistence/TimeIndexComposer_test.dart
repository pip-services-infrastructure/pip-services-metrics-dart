import 'package:test/test.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

void main() {
  group('TimeIndexComposerTest', () {
    
    test('TestComposeIndex', () {
      var index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Total, 2018, 8, 26, 14, 33);
      expect('total', index);

      index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Year, 2018, 8, 26, 14, 33);
      expect('2018', index);

      index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Month, 2018, 8, 26, 14, 33);
      expect('201808', index);

      index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Day, 2018, 8, 26, 14, 33);
      expect('20180826', index);

      index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Hour, 2018, 8, 26, 14, 33);
      expect('2018082614', index);

      index = TimeIndexComposer.composeIndex(
          TimeHorizonV1.Minute, 2018, 8, 26, 14, 33);
      expect('201808261433', index);
    });

    test('TestComposeIndexFromUpdate', () {
      var update = MetricUpdateV1();

      update.name = 'test';
      update.year = 2018;
      update.month = 8;
      update.day = 26;
      update.hour = 14;
      update.minute = 30;
      update.value = 123;

      var index =
          TimeIndexComposer.composeIndexFromUpdate(TimeHorizonV1.Total, update);
      expect('total', index);

      index = TimeIndexComposer.composeIndexFromUpdate(
          TimeHorizonV1.Minute, update);
      expect('201808261430', index);
    });

    test('TestComposeFromIndexFromFilter', () {
      var filter =
          FilterParams.fromTuples(['name', 'test', 'time_horizon', 'total']);
      var index = TimeIndexComposer.composeFromIndexFromFilter(
          TimeHorizonV1.Total, filter);
      expect('total', index);

      filter = FilterParams.fromTuples([
        'name',
        'test',
        'time_horizon',
        'hour',
        'from_year',
        2018,
        'from_month',
        8,
        'from_day',
        26,
        'from_hour',
        14,
        'from_minute',
        30
      ]);
      index = TimeIndexComposer.composeFromIndexFromFilter(
          TimeHorizonV1.Minute, filter);
      expect('201808261430', index);
    });

    test('TestComposeToIndexFromFilter', () {
      var filter =
          FilterParams.fromTuples(['name', 'test', 'time_horizon', 'total']);
      var index = TimeIndexComposer.composeToIndexFromFilter(
          TimeHorizonV1.Total, filter);
      expect('total', index);

      filter = FilterParams.fromTuples([
        'name',
        'test',
        'time_horizon',
        'hour',
        'to_year',
        2018,
        'to_month',
        8,
        'to_day',
        26,
        'to_hour',
        14,
        'to_minute',
        30
      ]);
      index = TimeIndexComposer.composeToIndexFromFilter(
          TimeHorizonV1.Minute, filter);
      expect('201808261430', index);
    });
  });
}
