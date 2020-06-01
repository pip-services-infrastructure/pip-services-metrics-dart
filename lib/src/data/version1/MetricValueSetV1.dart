
import './MetricValueV1.dart';
import  './TimeHorizonV1.dart';

class MetricValueSetV1 {
    String name;
    int time_horizon;
    String dimension1;
    String dimension2;
    String dimension3;
    List<MetricValueV1> values;
}