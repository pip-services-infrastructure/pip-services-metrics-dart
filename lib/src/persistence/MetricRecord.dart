import 'package:pip_services3_commons/pip_services3_commons.dart';

import './MetricRecordValue.dart';

class MetricRecord implements IIdentifiable<String> {
  @override
  String id;

  String name;
  int th;
  int rng;
  String d1;
  String d2;
  String d3;
  Map<String, MetricRecordValue> val;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    th = json['th'];
    rng = json['rng'];
    d1 = json['d1'];
    d2 = json['d2'];
    d3 = json['d3'];
    var items = json['val'];
    val = Map<String, MetricRecordValue>.from(items.map((key, item) {
      return MapEntry(key as String, MetricRecordValue.fromJson(item));
    }));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'th': th,
      'rng': rng,
      'd1': d1,
      'd2': d2,
      'd3': d3,
      'val': val,
    };
  }
}
