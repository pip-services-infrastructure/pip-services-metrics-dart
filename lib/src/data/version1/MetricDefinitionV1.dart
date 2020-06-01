
class MetricDefinitionV1 {
    String name;
    List<String> dimension1;
    List<String> dimension2;
    List<String> dimension3;

    Map<String, dynamic> toJson(){
      return <String, dynamic>{
          'name' : name,
          'dimension1':dimension1,
          'dimension2':dimension2,
          'dimension3':dimension3
      };
    }

    void fromJson(Map<String, dynamic> json){
      name = json['name'];
      dimension1 = json['dimension1'];
      dimension2 = json['dimension2'];
      dimension3 = json['dimension3'];
    }
}
