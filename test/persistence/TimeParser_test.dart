
import 'package:test/test.dart';
import  'package:pip_services_metrics/pip_services_metrics.dart';

void main(){

group('TimeParserTest', ()  {

    test('TestParsedTime', ()  {
        // Try to get deleted beacon
        var value = MetricValueV1();

        TimeParser.parseTime('total', TimeHorizonV1.Total, value);
            expect(value.year, isNull);
            expect(value.month, isNull);
            expect(value.day, isNull);
            expect(value.hour, isNull);
            expect(value.minute, isNull);
        
        TimeParser.parseTime('2018', TimeHorizonV1.Year, value);
            expect(2018, value.year);
            expect(value.month, isNull);
            expect(value.day, isNull);
            expect(value.hour, isNull);
            expect(value.minute, isNull);
        
        TimeParser.parseTime('201808', TimeHorizonV1.Month, value);
            expect(2018, value.year);
            expect(8, value.month);
            expect(value.day, isNull);
            expect(value.hour, isNull);
            expect(value.minute, isNull);
        
        TimeParser.parseTime('20180826', TimeHorizonV1.Day, value);
            expect(2018, value.year);
            expect(8, value.month);
            expect(26, value.day);
            expect(value.hour, isNull);
            expect(value.minute, isNull);

        TimeParser.parseTime('2018082614', TimeHorizonV1.Hour, value);
            expect(2018, value.year);
            expect(8, value.month);
            expect(26, value.day);
            expect(14, value.hour);
            expect(value.minute, isNull);
    
        TimeParser.parseTime('201808261430', TimeHorizonV1.Minute, value);
            expect(2018, value.year);
            expect(8, value.month);
            expect(26, value.day);
            expect(14, value.hour);
            expect(30, value.minute);
    });

});
}