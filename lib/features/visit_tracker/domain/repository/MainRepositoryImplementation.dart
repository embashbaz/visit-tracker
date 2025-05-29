

import 'package:dartz/dartz.dart';

import 'package:visit_tracker/data/remote/models/ApiFailure.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/data/remote/models/VisitApiResponse.dart';

import 'package:visit_tracker/features/visit_tracker/domain/model/Visit.dart';

import '../../../../data/remote/api/DioApiService.dart';
import '../../../../data/remote/models/ActivityApiResponse.dart';
import 'MainRepository.dart';

class MainRepositoryImplementation extends MainRepository {
  final DioApiService _dioApiService;

  MainRepositoryImplementation(this._dioApiService,);

  @override
  Future<Either<ApiFailure, Visit>> addVisit(Visit visit) async {
      final apiVisit = visit.toVisitApiResponse();
      final addVisit = await _dioApiService.addVisit(apiVisit);
      if (addVisit.isLeft()) {
        return left(addVisit.swap().getOrElse(() =>
            ApiFailure(code: 'UNKNOWN', message: 'Unknown')));
      }
      final newVisit = addVisit.getOrElse(() =>VisitApiResponse());
      return right(Visit.fromVisitApiResponse(newVisit));
  }


    @override
    Future<Either<ApiFailure, List<Visit>>> getAllVisits() async {
      // Get raw visits
      final visitsResult = await _dioApiService.getAllVisits();
      final customersResult = await _dioApiService.getAllCustomers();
      final activitiesResult = await _dioApiService.getAllActivities();

      if (visitsResult.isLeft()) {
        return left(visitsResult.swap().getOrElse(() =>
          ApiFailure(code: 'UNKNOWN', message: 'Unknown')));
      }
      if (customersResult.isLeft()) {
        return left(
          customersResult.swap().getOrElse(() =>
              ApiFailure(code: 'UNKNOWN', message: 'Unknown')));
      }
      if (activitiesResult.isLeft()) {
        return left(
          activitiesResult.swap().getOrElse(() =>
              ApiFailure(code: 'UNKNOWN', message: 'Unknown')));
      }

      final visits = visitsResult.getOrElse(() => []);
      final customers = customersResult.getOrElse(() => []);
      final activities = activitiesResult.getOrElse(() => []);

      final customerMap = {for (var c in customers) c.id: c};

      final activityMap = {for (var a in activities) a.id.toString(): a};

      final enrichedVisits = visits.map((v) {
        final customer = customerMap[v.customerId];
        final activityList = v.activitiesDone?.map((id) => activityMap[id])
            .whereType<Activity>()
            .toList();

        return Visit(
          id: v.id,
          customer: customer,
          visitDate: v.visitDate,
          status: v.status,
          location: v.location,
          notes: v.notes,
          activitiesDone: activityList,
          createdAt: v.createdAt,
        );
      }).toList();

      return right(enrichedVisits);
    }

  @override
  Future<Either<ApiFailure, List<Activity>>> getAllActivities() {
    return _dioApiService.getAllActivities();
  }

  @override
  Future<Either<ApiFailure, List<Customer>>> getAllCustomers() {
    return _dioApiService.getAllCustomers();
  }


}