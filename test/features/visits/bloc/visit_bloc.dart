import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:visit_tracker/common/bloc_utils.dart';
import 'package:visit_tracker/data/remote/models/ActivityApiResponse.dart';
import 'package:visit_tracker/data/remote/models/CustomerApiResponse.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/VisitBloc.dart';


import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_events.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_state.dart';
import 'package:visit_tracker/features/visit_tracker/domain/model/Visit.dart';
import 'package:visit_tracker/features/visit_tracker/domain/repository/MainRepository.dart';
import 'package:visit_tracker/data/remote/models/ApiFailure.dart';
import 'package:visit_tracker/features/visit_tracker/domain/repository/MainRepositoryImplementation.dart';

import '../repository/MockMainRepository.dart';

void main() {
  late VisitsBloc bloc;
  late MockMainRepository fakeRepo;

  setUp(() {
    fakeRepo = MockMainRepository();
    bloc = VisitsBloc(fakeRepo);
  });
  
  tearDown((){
    bloc.close();
  });



  group('VisitsBloc _onAddVisit', () {
    final customer = Customer(id: 1, name: 'Acme');
    final activity = Activity(id: 1, description: 'Demo');
    final now = DateTime(2020, 1, 1);;

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when customer is null',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: null,
        visitDate: now,
        status: 'Completed',
        location: 'Test',
        notes: 'Note',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('Customer is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when visitDate is null',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: null,
        status: 'Completed',
        location: 'Test',
        notes: 'Note',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('Visit date is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when status is null',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: null,
        location: 'Test',
        notes: 'Note',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('Status is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when activitiesDone is null',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: 'Completed',
        location: 'Test',
        notes: 'Note',
        activitiesDone: null,
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('At least one activity is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when activitiesDone is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: 'Completed',
        location: 'Test',
        notes: 'Note',
        activitiesDone: [],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('At least one activity is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when location is null or empty',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: 'Completed',
        location: '',
        notes: 'Note',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('Location is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits ErrorState when notes is null or empty',
      build: () => bloc,
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: 'Completed',
        location: 'Test',
        notes: '',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<ErrorState>().having((s) => s.message, 'message', contains('Notes is required')),
      ],
    );

    blocTest<VisitsBloc, AppState>(
      'emits [LoadingState, OnAddVisitSuccessState] when addVisit succeeds',
      build: () {
        fakeRepo.visits = [];
        return bloc;
      },
      act: (bloc) => bloc.add(AddedVisitEventSink(
        customer: customer,
        visitDate: now,
        status: 'Completed',
        location: 'Test Location',
        notes: 'Note here',
        activitiesDone: [activity],
      )),
      expect: () => [
        isA<LoadingState>(),
        isA<OnAddVisitSuccessState>(),
      ],
    );


  });

}
