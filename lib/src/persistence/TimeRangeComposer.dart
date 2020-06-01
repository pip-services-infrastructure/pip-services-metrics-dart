import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/TimeHorizonV1.dart';
import '../data/version1/MetricUpdateV1.dart';

class TimeRangeComposer {
  static int composeRange(
      int timeHorizon, int year, int month, int day, int hour, int minute) {
    switch (timeHorizon) {
      case TimeHorizonV1.Total:
        return 0;
      case TimeHorizonV1.Year:
        return 0;
      case TimeHorizonV1.Month:
        return year;
      case TimeHorizonV1.Day:
        return year;
      case TimeHorizonV1.Hour:
        return year * 100 + month;
      case TimeHorizonV1.Minute:
        return year * 100 + month;
      default:
        return 0;
    }
  }

  static int composeRangeFromUpdate(int timeHorizon, MetricUpdateV1 update) {
    return composeRange(timeHorizon, update.year, update.month, update.day,
        update.hour, update.minute);
  }

  static int composeFromRangeFromFilter(int timeHorizon, FilterParams filter) {
    // Define from time
    var time = filter.getAsDateTime('from_time');
    var year = filter.getAsIntegerWithDefault('from_year', time.year);
    var month = filter.getAsIntegerWithDefault('from_month', time.month);
    var day = filter.getAsIntegerWithDefault('from_day', time.day);
    var hour = filter.getAsIntegerWithDefault('from_hour', time.hour);
    var minute = filter.getAsIntegerWithDefault('from_minute', time.minute);

    return composeRange(timeHorizon, year, month, day, hour, minute);
  }

  static int composeToRangeFromFilter(int timeHorizon, FilterParams filter) {
    // Define to time
    var time = filter.getAsDateTime('to_time');
    var year = filter.getAsIntegerWithDefault('to_year', time.year);
    var month = filter.getAsIntegerWithDefault('to_month', time.month);
    var day = filter.getAsIntegerWithDefault('to_day', time.day);
    var hour = filter.getAsIntegerWithDefault('to_hour', time.hour);
    var minute = filter.getAsIntegerWithDefault('to_minute', time.minute);

    return composeRange(timeHorizon, year, month, day, hour, minute);
  }
}
