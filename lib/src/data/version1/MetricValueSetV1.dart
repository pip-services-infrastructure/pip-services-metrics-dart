
import './MetricValueV1.dart';

class MetricValueSetV1 {
    String name;
    int time_horizon;
    String dimension1;
    String dimension2;
    String dimension3;
    List<MetricValueV1> values;

    MetricValueSetV1();

    factory MetricValueSetV1.fromJson(Map<String, dynamic> json){
        var c = MetricValueSetV1();
        c.fromJson(json);
        return c;
    }

    Map<String, dynamic> toJson() {
      return <String, dynamic>{
        'name':name,
        'time_horizon':time_horizon,
        'dimension1':dimension1,
        'dimension2':dimension2,
        'dimension3':dimension3
      };
    }

    void fromJson(Map<String, dynamic> json) {
        name = json['name'];
        time_horizon = json['time_horizon'];
        dimension1 = json['dimension1'];
        dimension2 = json['dimension2'];
        dimension3 = json['dimension3'];
    }
}