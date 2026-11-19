import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCounterEvent extends CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class SyncToApiEvent extends CounterEvent {}

class PullFromApiEvent extends CounterEvent {}

class PushToApiEvent extends CounterEvent {}

class ConnectionStatusChangedEvent extends CounterEvent {
  final bool isOnline;

  ConnectionStatusChangedEvent({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
