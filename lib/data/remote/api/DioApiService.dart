import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartz/dartz.dart';
import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/data/remote/models/VisitApiResponse.dart';

import '../models/ApiFailure.dart';



class DioApiService {
  final Dio _dio;

  DioApiService()
      : _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL']!,
    headers: {
      'apikey': dotenv.env['API_KEY']!,
    },
  ));

  Future<Either<ApiFailure, VisitApiResponse>> addVisit(VisitApiResponse visit) async {
    try {
      final response = await _dio.post(
        '/visits',
        data: visit.toJson(),
      );

      final newVisit = VisitApiResponse.fromJson(response.data);
      return right(newVisit);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final error = e.response!.data;
        return left(ApiFailure(
          code: error['code'],
          message: error['message'],
          details: error['details'],
        ));
      }
      return left(ApiFailure(
        code: 'UNKNOWN',
        message: e.message ?? 'Unknown error',
      ));
    }
  }

  Future<Either<ApiFailure, List<VisitApiResponse>>> getAllVisits() async {
    try {
      final response = await _dio.get('/visits');

      final data = response.data as List;
      final visits = data.map((e) => VisitApiResponse.fromJson(e)).toList();

      return right(visits);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final error = e.response!.data;
        return left(ApiFailure(
          code: error['code'],
          message: error['message'],
          details: error['details'],
        ));
      }
      return left(ApiFailure(
        code: 'UNKNOWN',
        message: e.message ?? 'Unknown error',
      ));
    }
  }

  Future<Either<ApiFailure, List<Activity>>> getAllActivities() async {
    try {
      final response = await _dio.get('/activities');

      final data = response.data as List;
      final activities = data.map((e) => Activity.fromJson(e)).toList();

      return right(activities);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final error = e.response!.data;
        return left(ApiFailure(
          code: error['code'],
          message: error['message'],
          details: error['details'],
        ));
      }
      return left(ApiFailure(
        code: 'UNKNOWN',
        message: e.message ?? 'Unknown error',
      ));
    }
  }

  Future<Either<ApiFailure, List<Customer>>> getAllCustomers() async {
    try {
      final response = await _dio.get('/customers');

      final data = response.data as List;
      final customers = data.map((e) => Customer.fromJson(e)).toList();

      return right(customers);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final error = e.response!.data;
        return left(ApiFailure(
          code: error['code'],
          message: error['message'],
          details: error['details'],
        ));
      }
      return left(ApiFailure(
        code: 'UNKNOWN',
        message: e.message ?? 'Unknown error',
      ));
    }
  }
}
