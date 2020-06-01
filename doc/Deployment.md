
# Deployment Guide <br/> Metrics service Microservice

Metrics service microservice can be used in different deployment scenarios.

* [Standalone Process](#process)

## <a name="process"></a> Standalone Process

The simplest way to deploy the microservice is to run it as a standalone process. 
This microservice is implemented in JavaScript and requires installation of Dart. 
You can get it from the official site at https://dart.dev/get-dart

**Step 1.** Download microservices by following [instructions](Download.md)

**Step 2.** Add **config.yml** file to the root of the microservice folder and set configuration parameters. 
See [Configuration Guide](Configuration.md) for details.

**Step 3.** Start the microservice using the command:

```bash
dart  ./bin/run.dart
```