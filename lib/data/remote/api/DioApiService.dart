import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartz/dartz.dart';
import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/data/remote/models/VisitApiResponse.dart';

import '../models/ApiFailure.dart';

class DioApiService {
  late Dio _dio;

  DioApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL']!,
        headers: {'apikey': dotenv.env['API_KEY']!},
      ),
    );
    initializeInterceptor(_dio);
  }
  initializeInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, responseInterceptorHandler) {
          debugPrint('${response.statusCode}  \n${response.data}');
          return responseInterceptorHandler.next(response);
        },
        onError: (error, errorInterceptorHandler) {
          debugPrint('${error.response?.statusCode}  \n${error}');
          return errorInterceptorHandler.next(error);
        },
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          debugPrint(
            '${options.method}  \n${options.path} \n${options.headers} \n${options.queryParameters} \n${options.data}',
          );
          return handler.next(options);
        },
      ),
    );
  }

  Future<Either<ApiFailure, VisitApiResponse>> addVisit(
    VisitApiResponse visit,
  ) async {
    try {
      final response = await _dio.post('/visits', data: visit.toJson());

      final newVisit = VisitApiResponse();
      return right(newVisit);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final error = e.response!.data;
        return left(
          ApiFailure(
            code: error['code'],
            message: error['message'],
            details: error['details'],
          ),
        );
      }
      return left(
        ApiFailure(code: 'UNKNOWN', message: e.message ?? 'Unknown error'),
      );
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
        return left(
          ApiFailure(
            code: error['code'],
            message: error['message'],
            details: error['details'],
          ),
        );
      }
      return left(
        ApiFailure(code: 'UNKNOWN', message: e.message ?? 'Unknown error'),
      );
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
        return left(
          ApiFailure(
            code: error['code'],
            message: error['message'],
            details: error['details'],
          ),
        );
      }
      return left(
        ApiFailure(code: 'UNKNOWN', message: e.message ?? 'Unknown error'),
      );
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
        return left(
          ApiFailure(
            code: error['code'],
            message: error['message'],
            details: error['details'],
          ),
        );
      }
      return left(
        ApiFailure(code: 'UNKNOWN', message: e.message ?? 'Unknown error'),
      );
    }
  }
}
