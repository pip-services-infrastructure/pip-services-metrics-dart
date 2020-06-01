import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

class MetricsHttpServiceV1 extends CommandableHttpService {
  MetricsHttpServiceV1() : super('v1/metrics') {
    dependencyResolver.put(
        'controller',
        Descriptor(
            'pip-services-metrics', 'controller', 'default', '*', '1.0'));
  }
}
