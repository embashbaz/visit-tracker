


import 'package:dartz/dartz.dart';

import '../../../../data/remote/models/ApiFailure.dart';
import '../model/Visit.dart';

abstract class MainRepository {


  Future<Either<ApiFailure, List<Visit>>> getAllVisits();

  Future<Either<ApiFailure, Visit>> addVisit(Visit visit);



}