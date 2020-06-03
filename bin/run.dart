import 'package:pip_services_metrics/pip_services_metrics.dart';

void main(List<String> argument) {
  try {
    var proc = MetricsProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}
