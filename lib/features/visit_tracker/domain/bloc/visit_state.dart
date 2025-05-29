import 'package:visit_tracker/features/visit_tracker/domain/model/Visit.dart';

import '../../../../common/bloc_utils.dart';
import '../../../../data/remote/models/ActivityApiResponse.dart';
import '../../../../data/remote/models/CustomerApiResponse.dart';

class GetVisitsSuccessState extends AppState {
  List<Visit>? visits;

  int? allVisitsCount;
  int? pendingVisitsCount;
  int? completedVisitsCount;
  int? cancelledVisitsCount;

  String? term;

  GetVisitsSuccessState({
    this.visits,
    this.allVisitsCount,
    this.pendingVisitsCount,
    this.completedVisitsCount,
    this.cancelledVisitsCount,
    this.term,
  });

  @override
  List<Object?> get props => [];
}

class GetSingleVisitSuccessState extends AppState {
  Visit? visit;

  GetSingleVisitSuccessState({this.visit});

  @override
  List<Object?> get props => [];
}

class OnAddVisitSuccessState extends AppState {
  Visit? visit;

  OnAddVisitSuccessState({this.visit});

  @override
  List<Object?> get props => [];
}

class GetNewVisitDataSuccessState extends AppState {
  List<Customer>? customers;
  List<Activity>? activities;

  /**
   * In case getting custers or activities fails, we can show an error message
   */
  String? errorMessage;

  GetNewVisitDataSuccessState({this.customers, this.activities, this.errorMessage});
  @override
  List<Object?> get props => [];
}
