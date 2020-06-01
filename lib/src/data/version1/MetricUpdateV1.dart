
class MetricUpdateV1 {
    String  name;
    int year;
    int  month;
    int day;
    int hour;
    int minute; // not requred
    String dimension1; // not requred
    String dimension2; // not requred
    String dimension3; // not requred
    double value;

    Map<String, dynamic> toJson(){
      return <String, dynamic>{
        'name':name,
        'year': year,
        'month':month,
        'day':day,
        'hour':hour,
        'minute':minute,
        'dimension1':dimension1,
        'dimension2':dimension2,
        'dimension3':dimension3
      };
    }

    void fromJson(Map<String, dynamic> json){
        name = json['name'];
        year = json['year'];
        month = json['month'];
        day = json['day'];
        hour = json['hour'];
        minute = json['minute'];
        dimension1 = json['dimension1'];
        dimension2 = json['dimension2'];
        dimension3 = json['dimension3'];
    }
}
