##  Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST, GRPC, Lambda, etc.),
please, refer to documentation of the specific protocol.

```dart
// Create or update metric struct
class MetricUpdateV1 {
    String  name;
    int year;
    int  month;
    int day;
    int hour;
    int minute; 
    String dimension1; 
    String dimension2; 
    String dimension3; 
    double value;
}
// Metric definition struct
class MetricDefinitionV1 {
  String name;
  List<String> dimension1;
  List<String> dimension2;
  List<String> dimension3;
}
// Metric value struct
class MetricValueSetV1 {
    String name;
    int time_horizon;
    String dimension1;
    String dimension2;
    String dimension3;
    List<MetricValueV1> values;
}
// Values of metric
class MetricValueV1 {
    int year; 
    int month; 
    int day; 
    int hour; 
    int minute; 
    int count;
    double sum;
    double max;
    double min;
}
// Time horizons
class TimeHorizonV1 {
    static const Total = 0;
    static const Year = 1;
    static const Month = 2;
    static const Day = 3;
    static const Hour = 4;
    static const Minute = 5;
}

abstract class IMetricsController {
  Future<List<MetricDefinitionV1>> getMetricDefinitions(String correlationId);
  Future<MetricDefinitionV1> getMetricDefinitionByName(
      String correlationId, String name);
  Future<DataPage<MetricValueSetV1>> getMetricsByFilter(
      String correlationId, FilterParams filter, PagingParams paging);
  Future updateMetric(
      String correlationId, MetricUpdateV1 update, int maxTimeHorizon);
  Future updateMetrics(
      String correlationId, List<MetricUpdateV1> updates, int maxTimeHorizon);
}

```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-infrastructure/pip-services-metrics-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.yaml** file to the root of the microservice folder and set configuration parameters.
As the starting point you can use example configuration from **config.example.yaml** file. 

Example of microservice configuration
```yaml
{    
---
- descriptor: "pip-services-commons:logger:console:default:1.0"
  level: "trace"

- descriptor: "pip-services-metrics:persistence:file:default:1.0"
  path: "./data/blobs"

- descriptor: "pip-services-metrics:controller:default:default:1.0"

- descriptor: "pip-services-metrics:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 3000
}
```
 
For more information on the microservice configuration see [Configuration Guide](Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use
Inside your code get the reference to the client SDK
```dart
 import 'package:pip_clients_metrics';
```

Define client configuration parameters.

```dart
// Client configuration
var httpConfig = ConfigParams.fromTuples([
            'connection.protocol', 'http',
            'connection.port', 3000,
            'connection.host', 'localhost'
]);
client.configure(httpConfig);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
client = MetricssHttpClientV1();

// Connect to the microservice
try {
await client.open(null);
catch (err){
    print('Connection to the microservice failed');
    printr(err);
    return;
}
// Work with the microservice
...

```
Now the client is ready to perform operations:

Update if exist metric or create otherwise:
```dart 
try{
    await client.updateMetric(
                    null,
                    MetricUpdateV1()
                        ..name = "metric1"
                        ..dimension1 = "A"
                        ..dimension2 = "B"
                        ..dimension3 = null
                        ..year = 2018
                        ..month = 8
                        ..day = 26
                        ..hour = 12
                        ..value = 123
                    ,
                    TimeHorizonV1.Hour);
} catch(err) {
    console.error('Update/create metric are failed');
    console.error(err);
}

```

Update if exist metrics or create otherwise::
```dart
try{ 
    await client.updateMetrics(
                    null,
                    [
                        MetricUpdateV1() 
                            ..name = "metric1",
                            ..dimension1 = "A",
                            ..dimension2 = "B",
                            ..dimension3 = null,
                            ..year = 2018,
                            ..month = 8,
                            ..day = 26,
                            ..hour = 13,
                            ..value = 321
                        ,
                        MetricUpdateV1() 
                            ..name = "metric2"
                            ..dimension1 = "A"
                            ..dimension2 = null
                            ..dimension3 = "C"
                            ..year = 2018
                            ..month = 8
                            ..day = 26
                            ..hour = 13
                            ..value = 321
                        }        
                    ],
                    TimeHorizonV1.Hour);
} catch(err){               
    console.error('Update/create metric are failed');
    console.error(err);                 
}    
                

```

Get metrics by filter:
```dart
try {    
    var page = await client.getMetricsByFilter(null,
                    FilterParams.fromTuples(["name", "metric1"]),
                    new PagingParams());
    console.log("Metrics:");
    console.log(page.data);

} catch(err) {
    console.error("Can\'t get metrics by filter");
    console.error(err);                      
}
    
```

Get all metrics definitions:
```dart 
try {   
    var definitions = await client.getMetricDefinitions(null);
    console.log("All metrics definition:");
    console.log(definitions);
} catch (err){
                    
    console.error("Can\'t get metrics definitions");
    console.error(err);
}
    
```

Get metric definition by name:
```dart 
try {   
    var definition = await client.getMetricDefinitionByName(
                    null, 
                    "metric2");
    console.log("Metric definition name %s:", definition.name);
    console.log(definition);
} catch(err) {
                        
    console.error("Can\'t get metrics definition by name");
    console.error(err);
}               
    
```