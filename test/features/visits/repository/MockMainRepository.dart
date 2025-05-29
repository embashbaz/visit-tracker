import 'package:dartz/dartz.dart';
import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/ApiFailure.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/features/visit_tracker/domain/model/Visit.dart';
import 'package:visit_tracker/features/visit_tracker/domain/repository/MainRepository.dart';

class MockMainRepository implements MainRepository {
  List<Visit> visits = [];
  List<Customer> customers = [];
  List<Activity> activities = [];



  @override
  Future<Either<ApiFailure, List<Visit>>> getAllVisits() async {
    return right(
      visits
    );
  }

  @override
  Future<Either<ApiFailure, Visit>> addVisit(Visit visit) async {
    final newVisit = Visit();
    return right(newVisit);
  }

  @override
  Future<Either<ApiFailure, List<Customer>>> getAllCustomers() async {
    return right([
      Customer(id: 1, name: 'Acme Corp'),
      Customer(id: 2, name: 'Beta Ltd'),
    ]);
  }

  @override
  Future<Either<ApiFailure, List<Activity>>> getAllActivities() async {
    return right([
      Activity(id: 1, description: 'Demo'),
      Activity(id: 2, description: 'Training'),
      Activity(id: 3, description: 'Support'),
    ]);
  }
}
