import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_metrics/pip_services_metrics.dart';

class MetricsServiceFactory extends Factory {
     static final descriptor = Descriptor('pip-services-metrics', 'factory', 'service', 'default', '1.0');
     static final MemoryPersistenceDescriptor = Descriptor('pip-services-metrics', 'persistence', 'memory', '*', '1.0');
     static final FilePersistenceDescriptor = Descriptor('pip-services-metrics', 'persistence', 'file', '*', '1.0');
     static final MongoDbPersistenceDescriptor = Descriptor('pip-services-metrics', 'persistence', 'mongodb', '*', '1.0');
     static final ControllerDescriptor = Descriptor('pip-services-metrics', 'controller', 'default', '*', '1.0');
     static final HttpServiceDescriptor = Descriptor('pip-services-metrics', 'service', 'http', '*', '1.0');

     MetricsServiceFactory(): super() {
        registerAsType(MetricsServiceFactory.MemoryPersistenceDescriptor, MetricsMemoryPersistence);
        registerAsType(MetricsServiceFactory.FilePersistenceDescriptor, MetricsFilePersistence);
        registerAsType(MetricsServiceFactory.MongoDbPersistenceDescriptor, MetricsMongoDbPersistence);
        registerAsType(MetricsServiceFactory.ControllerDescriptor, MetricsController);
        registerAsType(MetricsServiceFactory.HttpServiceDescriptor, MetricsHttpServiceV1);
    }
}

