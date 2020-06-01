import 'dart:collection';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import './MetricRecordValue.dart';

class MetricRecordValueMap extends MapBase {
  final _values = <String, MetricRecordValue>{};

  @override
  MetricRecordValue operator [](Object key) {
    return _values[key];
  }

  @override
  void operator []=(key, value) {
    _values[key] = value;
  }

  @override
  void clear() {
    _values.clear();
  }

  @override
  Iterable<String> get keys => _values.keys;

  @override
  Object remove(Object key) {
    return _values.remove(key);
  }

  @override
  Iterable<MetricRecordValue> get values => _values.values;
}

class MetricRecord implements IIdentifiable<String> {
  @override
  String id;

  String name;
  int th;
  int rng;
  String d1;
  String d2;
  String d3;
  MetricRecordValueMap val;
}
