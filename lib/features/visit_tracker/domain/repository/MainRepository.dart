


import 'package:dartz/dartz.dart';
import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';

import '../../../../data/remote/models/ApiFailure.dart';
import '../model/Visit.dart';

abstract class MainRepository {


  Future<Either<ApiFailure, List<Visit>>> getAllVisits();

  Future<Either<ApiFailure, Visit>> addVisit(Visit visit);

  Future<Either<ApiFailure, List<Customer>>> getAllCustomers();

  Future<Either<ApiFailure, List<Activity>>> getAllActivities();


}