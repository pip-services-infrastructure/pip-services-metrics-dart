import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/TimeHorizonV1.dart';
import '../data/version1/MetricValueV1.dart';

class TimeParser {
     static void parseTime(String token, int timeHorizon, MetricValueV1 value) {
        if (timeHorizon == TimeHorizonV1.Total) {
            return;
        }
        if (token.length >= 4) {
            value.year = IntegerConverter.toInteger(token.substring(0, 4));
        }
        if (token.length >= 6) {
            value.month = IntegerConverter.toInteger(token.substring(4, 6));
        }
        if (token.length >= 8) {
            value.day = IntegerConverter.toInteger(token.substring(6, 8));
        }
        if (token.length >= 10) {
            value.hour = IntegerConverter.toInteger(token.substring(8, 10));
        }
        if (token.length >= 12) {
            value.minute = IntegerConverter.toInteger(token.substring(10, 12));
        }
    }
}