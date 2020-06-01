import '../data/version1/TimeHorizonV1.dart';
import '../data/version1/MetricUpdateV1.dart';
import './TimeRangeComposer.dart';

class MetricRecordIdComposer {
  static String _composeTime(
      int timeHorizon, int year, int month, int day, int hour, int minute) {
    var range = TimeRangeComposer.composeRange(
        timeHorizon, year, month, day, hour, minute);
    switch (timeHorizon) {
      case TimeHorizonV1.Total:
        return 'T';
      case TimeHorizonV1.Year:
        return 'Y';
      case TimeHorizonV1.Month:
        return 'M' + range.toString();
      case TimeHorizonV1.Day:
        return 'D' + range.toString();
      case TimeHorizonV1.Hour:
        return 'H' + range.toString();
      case TimeHorizonV1.Minute:
        return 'Q' + range.toString();
    }
    return 'X';
  }

  static String composeId(
      String name,
      int timeHorizon,
      String dimension1,
      String dimension2,
      String dimension3,
      int year,
      int month,
      int day,
      int hour,
      int minute) {
    return name +
        '_' +
        _composeTime(timeHorizon, year, month, day, hour, minute) +
        '_' +
        (dimension1 ?? '') +
        '_' +
        (dimension2 ?? '') +
        '_' +
        (dimension3 ?? '');
  }

  static String composeIdFromUpdate(int timeHorizon, MetricUpdateV1 update) {
    return composeId(
        update.name,
        timeHorizon,
        update.dimension1,
        update.dimension2,
        update.dimension3,
        update.year,
        update.month,
        update.day,
        update.hour,
        update.minute);
  }
}
