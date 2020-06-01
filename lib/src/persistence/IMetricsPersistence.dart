
import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/MetricUpdateV1.dart';
import './MetricRecord.dart';

 abstract class IMetricsPersistence {
    Future<DataPage<MetricRecord>> getPageByFilter(String correlationId, FilterParams filter , PagingParams paging);
    Future<MetricRecord> set(String correlationId, MetricRecord item);
    Future updateOne(String correlationId, MetricUpdateV1 update, int maxTimeHorizon);
    Future updateMany(String correlationId, List<MetricUpdateV1> updates, int maxTimeHorizon);
    Future deleteByFilter(String correlationId, filter); // FilterParams
}

