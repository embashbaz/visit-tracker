import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';

import '../../../../common/bloc_utils.dart';
import '../../../../data/remote/models/CustomerApiResponse.dart';

class GetVisitsEventSink extends AppEvent {
  GetVisitsEventSink({this.term});

  String? term;

  @override
  List<Object?> get props => [];
}

class AddedVisitEventSink extends AppEvent {
  DateTime? visitDate;
  String? status;
  String? location;
  String? notes;
  List<Activity>? activitiesDone;
  Customer? customer;

  AddedVisitEventSink({
    this.visitDate,
    this.status,
    this.location,
    this.notes,
    this.activitiesDone,
    this.customer,
  });

  @override
  List<Object?> get props => [];
}

/**
 * This is is used to get data needed for creating a new vist
 * Customers and Activities
 */
class GetNewVisitDataEventSink extends AppEvent {
  GetNewVisitDataEventSink();
  @override
  List<Object?> get props => [];

}

class GetSingleVisitEventSink extends AppEvent {
  GetSingleVisitEventSink({this.visitId});

  int? visitId;

  @override
  List<Object?> get props => [];
}

