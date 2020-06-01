import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/MetricDefinitionV1.dart';
import '../data/version1/MetricUpdateV1.dart';
import '../data/version1/MetricValueSetV1.dart';

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
