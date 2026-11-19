import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';
import 'repository/counter_repository.dart';
import 'services/sync_service.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository repository;
  final SyncService syncService;

  CounterBloc({
    required this.repository,
    required this.syncService,
  }) : super(const CounterState(counterValue: 0)) {
    on<LoadCounterEvent>((event, emit) async {
      final value = await repository.getCounter();
      emit(CounterState(
        counterValue: value,
        isOnline: await syncService.networkService.isConnected(),
      ));
    });

    on<IncrementEvent>((event, emit) async {
      final newValue = state.counterValue + 1;
      await repository.saveCounter(newValue);
      await syncService.syncCounterToApi(newValue);
      emit(state.copyWith(counterValue: newValue));
    });

    on<DecrementEvent>((event, emit) async {
      final newValue = state.counterValue - 1;
      await repository.saveCounter(newValue);
      await syncService.syncCounterToApi(newValue);
      emit(state.copyWith(counterValue: newValue));
    });

    on<SyncToApiEvent>((event, emit) async {
      emit(state.copyWith(isSyncing: true, syncMessage: 'Syncing...'));
      try {
        await syncService.syncCounterToApi(state.counterValue);
        emit(state.copyWith(
          isSyncing: false,
          syncMessage: 'Synced successfully',
        ));
      } catch (e) {
        emit(state.copyWith(
          isSyncing: false,
          syncMessage: 'Sync failed: $e',
        ));
      }
    });

    on<PullFromApiEvent>((event, emit) async {
      emit(state.copyWith(isSyncing: true, syncMessage: 'Pulling from API...'));
      try {
        final remoteValue = await syncService.fetchCounterFromApi();
        await repository.saveCounter(remoteValue);
        emit(state.copyWith(
          counterValue: remoteValue,
          isSyncing: false,
          syncMessage: 'Pulled successfully',
        ));
      } catch (e) {
        emit(state.copyWith(
          isSyncing: false,
          syncMessage: 'Pull failed: $e',
        ));
      }
    });

    on<PushToApiEvent>((event, emit) async {
      emit(state.copyWith(isSyncing: true, syncMessage: 'Pushing to API...'));
      try {
        await syncService.pushToApi();
        emit(state.copyWith(
          isSyncing: false,
          syncMessage: 'Pushed successfully',
        ));
      } catch (e) {
        emit(state.copyWith(
          isSyncing: false,
          syncMessage: 'Push failed: $e',
        ));
      }
    });

    on<ConnectionStatusChangedEvent>((event, emit) async {
      emit(state.copyWith(
        isOnline: event.isOnline,
        syncMessage: event.isOnline ? 'Online' : 'Offline',
      ));

      if (event.isOnline) {
        await syncService.pushToApi();
      }
    });
  }
}