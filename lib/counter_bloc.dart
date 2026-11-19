import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';
import 'repository/counter_repository.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository repository;

  CounterBloc({required this.repository}) : super(const CounterState(counterValue: 0)) {
    on<LoadCounterEvent>((event, emit) async {
      final value = await repository.getCounter();
      emit(CounterState(counterValue: value));
    });

    on<IncrementEvent>((event, emit) async {
      final newValue = state.counterValue + 1;
      await repository.saveCounter(newValue);
      emit(CounterState(counterValue: newValue));
    });

    on<DecrementEvent>((event, emit) async {
      final newValue = state.counterValue - 1;
      await repository.saveCounter(newValue);
      emit(CounterState(counterValue: newValue));
    });
  }
}