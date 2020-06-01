import 'package:pip_services3_commons/pip_services3_commons.dart';

class MetricUpdateV1Schema extends ObjectSchema {
     MetricUpdateV1Schema():super() {
        
        withRequiredProperty('name', TypeCode.String);
        withRequiredProperty('year', TypeCode.Integer);
        withRequiredProperty('month', TypeCode.Integer);
        withRequiredProperty('day', TypeCode.Integer);
        withRequiredProperty('hour', TypeCode.Integer);
        withOptionalProperty('minute', TypeCode.Integer);
        withOptionalProperty('dimension1', TypeCode.String);
        withOptionalProperty('dimension2', TypeCode.String);
        withOptionalProperty('dimension3', TypeCode.String);
        withRequiredProperty('value', TypeCode.Float);
    }
}

