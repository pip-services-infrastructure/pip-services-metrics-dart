import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';

class MetricsProcess extends ProcessContainer {
    MetricsProcess():super('pip-services-metrics', 'Analytical metrics microservice') {
      
        factories.add(DefaultRpcFactory());
        factories.add(MetricsServiceFactory());
    }
}
