import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/TimeHorizonV1.dart';
import '../data/version1/MetricUpdateV1.dart';

class TimeIndexComposer {
  static String composeIndex(
      int timeHorizon, int year, int month, int day, int hour, int minute) {
    switch (timeHorizon) {
      case TimeHorizonV1.Total:
        return 'total';
      case TimeHorizonV1.Year:
        return '' + year.toString();
      case TimeHorizonV1.Month:
        return '' + (year * 100 + month).toString();
      case TimeHorizonV1.Day:
        return '' + (year * 10000 + month * 100 + day).toString();
      case TimeHorizonV1.Hour:
        return '' +
            (year * 1000000 + month * 10000 + day * 100 + hour).toString();
      case TimeHorizonV1.Minute:
        //minute = ((minute / 15) * 15).toInt();
        return '' +
            (year * 100000000 +
                    month * 1000000 +
                    day * 10000 +
                    hour * 100 +
                    minute)
                .toString();
      default:
        return '';
    }
  }

  static String composeIndexFromUpdate(int timeHorizon, MetricUpdateV1 update) {
    return composeIndex(timeHorizon, update.year, update.month, update.day,
        update.hour, update.minute);
  }

  static String composeFromIndexFromFilter(
      int timeHorizon, FilterParams filter) {
    // Define from time
    var time = filter.getAsDateTime('from_time');
    var year = filter.getAsIntegerWithDefault('from_year', time.year);
    var month = filter.getAsIntegerWithDefault('from_month', time.month);
    var day = filter.getAsIntegerWithDefault('from_day', time.day);
    var hour = filter.getAsIntegerWithDefault('from_hour', time.hour);
    var minute = filter.getAsIntegerWithDefault('from_minute', time.minute);

    return composeIndex(timeHorizon, year, month, day, hour, minute);
  }

  static String composeToIndexFromFilter(int timeHorizon, FilterParams filter) {
    // Define to time
    var time = filter.getAsDateTime('to_time');
    var year = filter.getAsIntegerWithDefault('to_year', time.year);
    var month = filter.getAsIntegerWithDefault('to_month', time.month);
    var day = filter.getAsIntegerWithDefault('to_day', time.day);
    var hour = filter.getAsIntegerWithDefault('to_hour', time.hour);
    var minute = filter.getAsIntegerWithDefault('to_minute', time.minute);

    return composeIndex(timeHorizon, year, month, day, hour, minute);
  }
}
