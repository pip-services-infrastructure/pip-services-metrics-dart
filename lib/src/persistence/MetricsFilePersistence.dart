import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';

import './MetricsMemoryPersistence.dart';
import './MetricRecord.dart';

class MetricsFilePersistence extends MetricsMemoryPersistence {
  JsonFilePersister<MetricRecord> persister;

  MetricsFilePersistence([String path]) : super() {
    persister = JsonFilePersister<MetricRecord>(path);
    loader = persister;
    saver = persister;
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}
