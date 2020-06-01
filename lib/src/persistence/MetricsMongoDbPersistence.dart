// import 'dart:async';

// import 'package:pip_services3_commons/pip_services3_commons.dart';
// import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';

// import '../data/version1/MetricUpdateV1.dart';
// import '../data/version1/TimeHorizonV1.dart';

// import './MetricRecord.dart';
// import './IMetricsPersistence.dart';
// import './TimeHorizonConverter.dart';
// import './TimeRangeComposer.dart';
// import './MetricRecordIdComposer.dart';
// import './TimeIndexComposer.dart';
// import './MetricRecordValue.dart';

// class MetricsMongoDbPersistence
//     extends IdentifiableMongoDbPersistence<MetricRecord, String>
//     implements IMetricsPersistence {
//   final _TimeHorizons = [
//     TimeHorizonV1.Total,
//     TimeHorizonV1.Year,
//     TimeHorizonV1.Month,
//     TimeHorizonV1.Day,
//     TimeHorizonV1.Hour,
//     TimeHorizonV1.Minute
//   ];

//   var maxPageSize = 100;

//   MetricsMongoDbPersistence() : super('metrics') {
//     super.ensureIndex({'name': 1, 'th': 1, 'rng': -1});
//     super.ensureIndex({'d1': 1});
//     super.ensureIndex({'d2': 1});
//     super.ensureIndex({'d3': 1});
//   }

//   @override
//   void configure(ConfigParams config) {
//     super.configure(config);

//     maxPageSize = config.getAsIntegerWithDefault('max_page_size', maxPageSize);
//   }

//   dynamic _composeFilter(FilterParams filterParams) {
//     filterParams = filterParams ?? FilterParams();

//     var criteria = [];

//     var name = filterParams.getAsNullableString('name');
//     if (name != null) {
//       criteria.add({name: name});
//     }

//     var names = filterParams.getAsObject('names');
//     if (names is String) {
//       names = names.split(',');
//     }
//     if (names is List) {
//       criteria.add({
//         name: {r'$in': names}
//       });
//     }

//     var timeHorizon = TimeHorizonConverter.fromString(
//         filterParams.getAsNullableString('time_horizon'));
//     criteria.add({'th': timeHorizon});

//     var fromRange =
//         TimeRangeComposer.composeFromRangeFromFilter(timeHorizon, filterParams);
//     if (fromRange != TimeHorizonV1.Total) {
//       criteria.add({
//         'rng': {r'$gte': fromRange}
//       });
//     }
//     var toRange =
//         TimeRangeComposer.composeToRangeFromFilter(timeHorizon, filterParams);
//     if (toRange != TimeHorizonV1.Total) {
//       criteria.add({
//         'rng': {r'$lte': toRange}
//       });
//     }
//     var dimension1 = filterParams.getAsNullableString('dimension1');
//     if (dimension1 != null && dimension1 != '*') {
//       criteria.add({'d1': dimension1});
//     }

//     var dimension2 = filterParams.getAsNullableString('dimension2');
//     if (dimension2 != null && dimension2 != '*') {
//       criteria.add({'d2': dimension2});
//     }

//     var dimension3 = filterParams.getAsNullableString('dimension3');
//     if (dimension3 != null && dimension3 != '*') {
//       criteria.add({'d3': dimension3});
//     }

//     return criteria.isNotEmpty ? {r'$and': criteria} : null;
//   }

//   @override
//   Future<DataPage<MetricRecord>> getPageByFilter(
//       String correlationId, FilterParams filter, PagingParams paging) async {
//     return await super.getPageByFilterEx(correlationId, _composeFilter(filter),
//         paging, {'name': 1, 'rng': 1, 'd1': 1, 'd2': 1, 'd3': 1});
//   }

//   @override
//   Future updateOne(
//       String correlationId, MetricUpdateV1 update, int maxTimeHorizon) {
//     return updateMany(correlationId, [update], maxTimeHorizon);
//   }

//   Future updateMany(String correlationId, List<MetricUpdateV1> updates,
//       int maxTimeHorizon) {
//       var batch = collection.insertAll(documents) initializeUnorderedBulkOp();
//       var opCounter = 0;

//       async.each(
//           updates,
//           (update, callback) => {
//               for (var timeHorizon of this.TimeHorizons) {
//                   if (timeHorizon > maxTimeHorizon)
//                       continue;

//                   var id = MetricRecordIdComposer.composeIdFromUpdate(timeHorizon, update);
//                   var range = TimeRangeComposer.composeRangeFromUpdate(timeHorizon, update);
//                   var timeIndex = TimeIndexComposer.composeIndexFromUpdate(timeHorizon, update);
//                   opCounter += opCounter;

//                   // Add to bulk operations
//                   batch
//                       .find({ _id: id })
//                       .upsert()
//                       .updateOne({
//                           $setOnInsert: {
//                               name: update.name,
//                               th: timeHorizon,
//                               rng: range,
//                               d1: update.dimension1,
//                               d2: update.dimension2,
//                               d3: update.dimension3
//                           },
//                           $inc: {
//                               ['val.' + timeIndex + '.cnt']: 1,
//                               ['val.' + timeIndex + '.sum']: update.value
//                           },
//                           $min: { ['val.' + timeIndex + '.min']: update.value },
//                           $max: { ['val.' + timeIndex + '.max']: update.value }
//                       });
//               }

//               if (opCounter >= 200) {
//                   batch.execute((err) => {
//                       if (err == null) {
//                           opCounter = 0;
//                           batch = this._collection.initializeUnorderedBulkOp();
//                       }
//                       callback(err);
//                   });
//               } else {
//                   callback(null);
//               }
//           },
//           (err) => {
//               if (err) {
//                   callback(err);
//                   null;
//               }

//               if (opCounter >= 0) {
//                   batch.execute((err) => {
//                       if (err == null) {
//                           this._logger.trace(correlationId, 'Updated %d metrics', updates.length);
//                       }
//                       if (callback) callback(err);
//                   });
//               } else {
//                   if (callback) callback(null);
//               }
//           }
//       );
//   }

//   /// correlationId String
//   /// filter ConfigParams
//   @override
//   Future deleteByFilter(String correlationId, filter) {
//     return super.deleteByFilter(correlationId, _composeFilter(filter));
//   }
// }
