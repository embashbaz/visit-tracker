


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AppState extends Equatable{
  AppEvent? get event => null;
  const AppState();

}

@immutable
abstract class AppEvent extends Equatable{
  const AppEvent();
}
class EmptyEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}


class EmptyState extends AppState {
  @override
  List<Object?> get props => [];

}

class ErrorState extends AppState {
  int? code;
  String message;

  @override
  AppEvent? event ;

  ErrorState(this.message, {this.code, this.event});

  @override
  List<Object?> get props => [message, code, event];

}


class LoadingState extends AppState {
  @override
  List<Object?> get props => [];

}

class NoDataReturnedState extends AppState {
  @override
  List<Object?> get props => [];

}