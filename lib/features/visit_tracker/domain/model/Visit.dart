import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/data/remote/models/VisitApiResponse.dart';

class Visit {
  final int? id;
  final CustomerApiResponse? customer;
  final DateTime? visitDate;
  final String? status;
  final String? location;
  final String? notes;
  final List<ActivityApiResponse>? activitiesDone;
  final DateTime? createdAt;

  Visit({
    this.id,
    this.customer,
    this.visitDate,
    this.status,
    this.location,
    this.notes,
    this.activitiesDone,
    this.createdAt,
  });

  factory Visit.fromVisitApiResponse(VisitApiResponse visit) {
    return Visit(
      id: visit.id,
      customer: CustomerApiResponse(id: visit.customerId),
      visitDate: visit.visitDate,
      status: visit.status,
      location: visit.location,
      activitiesDone: visit.activitiesDone?.map((a) => ActivityApiResponse(id: int.tryParse(a))).toList()
    );
  }

  VisitApiResponse toVisitApiResponse() {
    return VisitApiResponse(
      customerId: customer?.id,
        visitDate: visitDate,
        status: status,
        location: location,
        notes: notes,
        activitiesDone: activitiesDone?.map((a) => a.id.toString()).toList()
    );
  }

}