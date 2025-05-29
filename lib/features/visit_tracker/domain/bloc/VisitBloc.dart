import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_events.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_state.dart';

import '../../../../common/bloc_utils.dart';
import '../../../../data/remote/models/ApiFailure.dart';
import '../model/Visit.dart';
import '../repository/MainRepository.dart';

class VisitsBloc extends Bloc<AppEvent, AppState> {
  final MainRepository repository;
  List<Visit>? _cachedVisits;

  VisitsBloc(this.repository) : super(EmptyState()) {
    on<EmptyEvent>((event, emit) async {
      emit(EmptyState());
    });
    on<GetVisitsEventSink>(_onGetVisits);
    on<GetSingleVisitEventSink>(_onGetSingleVisit);
    on<AddedVisitEventSink>(_onAddVisit);
    on<GetNewVisitDataEventSink>(_onGetNewVisitData);
  }

  Future<void> _onGetVisits(
    GetVisitsEventSink event,
    Emitter<AppState> emit,
  ) async {
    emit(LoadingState());
    if (_cachedVisits == null) {
      await _onGetRemoteVisits();
    }

    final term = event.term;
    final filteredVisits = _filterVisits(term, _cachedVisits ?? []);

    int? allVisitsCount = _cachedVisits?.length;
    int? pendingVisitsCount =
        _cachedVisits?.where((v) => v.status == "Pending").length;
    int? completedVisitsCount =
        _cachedVisits?.where((v) => v.status == "Completed").length;
    int? cancelledVisitsCount =
        _cachedVisits?.where((v) => v.status == "Cancelled").length;

    emit(
      GetVisitsSuccessState(
        visits: filteredVisits,
        term: term,
        allVisitsCount: allVisitsCount,
        pendingVisitsCount: pendingVisitsCount,
        completedVisitsCount: completedVisitsCount,
        cancelledVisitsCount: cancelledVisitsCount,
      ),
    );
  }

  Future<void> _onGetSingleVisit(
    GetSingleVisitEventSink event,
    Emitter<AppState> emit,
  ) async {
    if (_cachedVisits == null) {
      emit(LoadingState());
      await _onGetRemoteVisits();
    }
    final visit = _cachedVisits?.firstWhere((v) => v.id == event.visitId);
    if (visit != null) {
      emit(GetSingleVisitSuccessState(visit: visit));
    }
  }

  Future<void> _onGetNewVisitData(
    GetNewVisitDataEventSink event,
    Emitter<AppState> emit,
  ) async {
    final customersResult = await repository.getAllCustomers();
    final activitiesResult = await repository.getAllActivities();

    String? errorMessage;

    final activities = activitiesResult.getOrElse(() => []);
    final customers = customersResult.getOrElse(() => []);

    if (customersResult.isLeft()) {
      errorMessage =
          customersResult
              .swap()
              .getOrElse(() => ApiFailure(code: 'UNKNOWN', message: 'Unknown'))
              .message;
    }
    if (activitiesResult.isLeft()) {
      errorMessage =
          activitiesResult
              .swap()
              .getOrElse(() => ApiFailure(code: 'UNKNOWN', message: 'Unknown'))
              .message;
    }
    emit(
      GetNewVisitDataSuccessState(
        customers: customers,
        activities: activities,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _onAddVisit(
    AddedVisitEventSink event,
    Emitter<AppState> emit,
  )
  async {
    if (event.customer == null) {
      emit(ErrorState('Customer is required'));
      return;
    }

    if (event.visitDate == null) {
      emit(ErrorState('Visit date is required'));
      return;
    }

    if (event.status == null) {
      emit(ErrorState('Status is required'));
      return;
    }

    if (event.activitiesDone == null || event.activitiesDone?.isEmpty == true) {
      emit(ErrorState('At least one activity is required'));
      return;
    }

    if (event.location == null || event.location?.isEmpty == true) {
      emit(ErrorState('Location is required'));
      return;
    }

    if (event.notes == null || event.notes?.isEmpty == true) {
      emit(ErrorState('Notes is required'));
      return;
    }
   emit(LoadingState());
    final visit = Visit(
      customer: event.customer,
      visitDate: event.visitDate,
      status: event.status,
      location: event.location,
      notes: event.notes,
      activitiesDone: event.activitiesDone,
      createdAt: DateTime.now(),
    );
    final result = await repository.addVisit(visit);
    result.fold(
      (failure) {
        emit(ErrorState(failure.message));
      },
      (visit) {
        print("success");
        emit(OnAddVisitSuccessState(visit: visit));
      },
    );
  }

  List<Visit> _filterVisits(String? term, List<Visit> visits) {
    if (term == null || term.trim().isEmpty) {
      return visits;
    }

    final regex = RegExp(term, caseSensitive: false);

    return visits.where((visit) {
      final customerName = visit.customer?.name ?? '';
      final location = visit.location ?? '';
      final status = visit.status ?? '';
      final notes = visit.notes ?? '';
      final activityDescriptions =
          visit.activitiesDone?.map((a) => a.description ?? '').join(' ') ?? '';

      return regex.hasMatch(customerName) ||
          regex.hasMatch(location) ||
          regex.hasMatch(status) ||
          regex.hasMatch(notes) ||
          regex.hasMatch(activityDescriptions);
    }).toList();
  }

  Future<void> _onGetRemoteVisits() async {
    final result = await repository.getAllVisits();
    result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        return;
      },
      (visits) {
        _cachedVisits = visits;
      },
    );
  }
}
