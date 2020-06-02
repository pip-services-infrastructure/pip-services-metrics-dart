import 'package:pip_services3_commons/pip_services3_commons.dart';

import './IMetricsController.dart';
import '../data/version1/MetricUpdateV1Schema.dart';
import '../data/version1/TimeHorizonV1.dart';
import '../data/version1/MetricUpdateV1.dart';

class MetricsCommandSet extends CommandSet {
    IMetricsController _controller;

    MetricsCommandSet(IMetricsController controller):super() {
        _controller = controller;

        addCommand(_makeGetMetricDefinitionsCommand());
        addCommand(_makeGetMetricDefinitionByNameCommand());
        addCommand(_makeGetMetricsByFilterCommand());
        addCommand(_makeUpdateMetricCommand());
        addCommand(_makeUpdateMetricsCommand());
    }

     ICommand _makeGetMetricDefinitionsCommand() {
        return Command(
            'get_metric_definitions',
            ObjectSchema(),
            (String correlationId, Parameters args)  {
                return  _controller.getMetricDefinitions(correlationId);
            });
    }

    ICommand _makeGetMetricDefinitionByNameCommand() {
        return Command(
            'get_metric_definition_by_name',
            ObjectSchema()
                .withOptionalProperty('name', TypeCode.String),
            (String correlationId, Parameters  args)  {
                var name = args.getAsString('name');
                return  _controller.getMetricDefinitionByName(correlationId, name);
            });
    }

    ICommand _makeGetMetricsByFilterCommand() {
        return Command(
            'get_metrics_by_filter',
            ObjectSchema(true)
                .withOptionalProperty('filter', FilterParamsSchema())
                .withOptionalProperty('paging', PagingParamsSchema()),
            (String correlationId, Parameters  args)  {
                var filter = FilterParams.fromValue(args.get('filter'));
                var paging = PagingParams.fromValue(args.get('paging'));

                return  _controller.getMetricsByFilter(correlationId, filter, paging);
            });
    }

    ICommand _makeUpdateMetricCommand() {
        return Command(
            'update_metric',
            ObjectSchema(true)
                .withRequiredProperty('update', MetricUpdateV1Schema())
                .withOptionalProperty('max_time_horizon', TypeCode.Long),
            (String correlationId, Parameters  args)  {
                var update = MetricUpdateV1.fromJson(args.getAsObject('update'));
                var maxTimeHorizon = args.getAsIntegerWithDefault('max_time_horizon', TimeHorizonV1.Hour);
                 _controller.updateMetric(correlationId, update, maxTimeHorizon);
                return null;
            });
    }

    ICommand _makeUpdateMetricsCommand() {
        return Command(
            'update_metrics',
            ObjectSchema(true)
                .withRequiredProperty('updates', ArraySchema(MetricUpdateV1Schema()))
                .withOptionalProperty('max_time_horizon', TypeCode.Long),
            (String correlationId, Parameters  args, )  {
                var updates = List<MetricUpdateV1>.from(args.getAsArray('updates').innerValue().map((item)=>MetricUpdateV1.fromJson(item)));
                var maxTimeHorizon = args.getAsIntegerWithDefault('max_time_horizon', TimeHorizonV1.Hour);
                 _controller.updateMetrics(correlationId, updates, maxTimeHorizon);
                return null;
            });
    }
}

