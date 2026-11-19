import 'package:doc/database/app_database.dart';
import 'package:doc/services/api_service.dart';
import 'package:doc/services/network_service.dart';

class SyncService {
  final AppDatabase database;
  final ApiService apiService;
  final NetworkService networkService;

  SyncService({
    required this.database,
    required this.apiService,
    required this.networkService,
  });

  Future<void> syncCounterToApi(int value) async {
    final isOnline = await networkService.isConnected();

    if (isOnline) {
      try {
        await apiService.saveCounter(value);
      } catch (e) {
        print('Failed to sync to API: $e');
      }
    }
  }

  Future<int> fetchCounterFromApi() async {
    final isOnline = await networkService.isConnected();

    if (isOnline) {
      try {
        return await apiService.getCounter();
      } catch (e) {
        print('Failed to fetch from API: $e');
        return await database.getCounter() ?? 0;
      }
    } else {
      return await database.getCounter() ?? 0;
    }
  }

  Future<void> pullFromApi() async {
    final isOnline = await networkService.isConnected();

    if (isOnline) {
      try {
        final remoteValue = await apiService.getCounter();
        await database.saveCounter(remoteValue);
      } catch (e) {
        print('Failed to pull from API: $e');
      }
    }
  }

  Future<void> pushToApi() async {
    final isOnline = await networkService.isConnected();

    if (isOnline) {
      try {
        final localValue = await database.getCounter() ?? 0;
        await apiService.saveCounter(localValue);
      } catch (e) {
        print('Failed to push to API: $e');
      }
    }
  }
}
