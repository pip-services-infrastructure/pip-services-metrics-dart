class MetricDefinitionV1 {
  String name;
  List<String> dimension1;
  List<String> dimension2;
  List<String> dimension3;

  MetricDefinitionV1();

  factory MetricDefinitionV1.fromJson(Map<String, dynamic> json) {
    var c = MetricDefinitionV1();
    c.fromJson(json);
    return c;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'dimension1': dimension1,
      'dimension2': dimension2,
      'dimension3': dimension3
    };
  }

  void fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dimension1 = List<String>.from(json['dimension1']);
    dimension2 = List<String>.from(json['dimension2']);
    dimension3 = List<String>.from(json['dimension3']);
  }
}
