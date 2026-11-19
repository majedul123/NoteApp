import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counterValue;
  final bool isOnline;
  final bool isSyncing;
  final String? syncMessage;

  const CounterState({
    required this.counterValue,
    this.isOnline = true,
    this.isSyncing = false,
    this.syncMessage,
  });

  CounterState copyWith({
    int? counterValue,
    bool? isOnline,
    bool? isSyncing,
    String? syncMessage,
  }) {
    return CounterState(
      counterValue: counterValue ?? this.counterValue,
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      syncMessage: syncMessage ?? this.syncMessage,
    );
  }

  @override
  List<Object?> get props => [counterValue, isOnline, isSyncing, syncMessage];
}