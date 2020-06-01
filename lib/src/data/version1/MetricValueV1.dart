class MetricValueV1 {
  int year; // not requre
  int month; // not requre
  int day; // not requre
  int hour; // not requre
  int minute; // not requre
  int count;
  double sum;
  double max;
  double min;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'count': count,
      'sum': sum,
      'max': max,
      'min': min
    };
  }

  void fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    count = json['count'];
    sum = json['sum'];
    max = json['max'];
    min = json['min'];
  }
}
