import 'package:test/test.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

void main() {
  group('TimeRangeComposerTest', () {
    test('TestComposeRange', () {
      var range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Total, 2018, 8, 26, 14, 33);
      expect(0, range);

      range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Year, 2018, 8, 26, 14, 33);
      expect(0, range);

      range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Month, 2018, 8, 26, 14, 33);
      expect(2018, range);

      range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Day, 2018, 8, 26, 14, 33);
      expect(2018, range);

      range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Hour, 2018, 8, 26, 14, 33);
      expect(201808, range);

      range = TimeRangeComposer.composeRange(
          TimeHorizonV1.Minute, 2018, 8, 26, 14, 33);
      expect(201808, range);
    });

    test('TestComposeRangeFromUpdate', () {
      var update = MetricUpdateV1();

      update.name = 'test';
      update.year = 2018;
      update.month = 8;
      update.day = 26;
      update.hour = 14;
      update.minute = 33;
      update.value = 123;

      var range =
          TimeRangeComposer.composeRangeFromUpdate(TimeHorizonV1.Total, update);
      expect(0, range);

      range =
          TimeRangeComposer.composeRangeFromUpdate(TimeHorizonV1.Hour, update);
      expect(201808, range);
    });

    test('TestComposeFromRangeFromFilter', () {
      var filter =
          FilterParams.fromTuples(['name', 'test', 'time_horizon', 'total']);
      var range = TimeRangeComposer.composeFromRangeFromFilter(
          TimeHorizonV1.Total, filter);
      expect(0, range);

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
        33
      ]);
      range = TimeRangeComposer.composeFromRangeFromFilter(
          TimeHorizonV1.Minute, filter);
      expect(201808, range);
    });

    test('TestComposeToRangeFromFilter', () {
      var filter =
          FilterParams.fromTuples(['name', 'test', 'time_horizon', 'total']);
      var range = TimeRangeComposer.composeToRangeFromFilter(
          TimeHorizonV1.Total, filter);
      expect(0, range);

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
        33
      ]);
      range = TimeRangeComposer.composeToRangeFromFilter(
          TimeHorizonV1.Minute, filter);
      expect(201808, range);
    });
  });
}
