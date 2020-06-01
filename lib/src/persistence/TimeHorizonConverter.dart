import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/TimeHorizonV1.dart';

class TimeHorizonConverter {
  static int fromString(String value) {
    if (value == null || value == '') {
      return TimeHorizonV1.Total;
    }

    value = value.toLowerCase();

    if (value == 'total') {
      return TimeHorizonV1.Total;
    }
    if (value == 'year' || value == 'yearly') {
      return TimeHorizonV1.Year;
    }
    if (value == 'month' || value == 'monthly') {
      return TimeHorizonV1.Month;
    }
    if (value == 'day' || value == 'daily') {
      return TimeHorizonV1.Day;
    }
    if (value == 'hour' || value == 'hourly') {
      return TimeHorizonV1.Hour;
    }

    var code =
        IntegerConverter.toIntegerWithDefault(value, TimeHorizonV1.Total);
    return code;
  }
}
