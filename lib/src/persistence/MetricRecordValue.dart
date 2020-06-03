class MetricRecordValue {
  int cnt;
  double sum;
  double max;
  double min;

  MetricRecordValue();

  factory MetricRecordValue.fromJson(Map<String, dynamic> json) {
    var c = MetricRecordValue();
    c.fromJson(json);
    return c;
  }

  void fromJson(Map<String, dynamic> json) {
    cnt = json['cnt'];
    sum = json['sum'];
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'cnt': cnt, 'sum': sum, 'max': max, 'min': min};
  }
}
