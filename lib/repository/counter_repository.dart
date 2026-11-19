import '../database/app_database.dart';

class CounterRepository {
  final AppDatabase database;

  CounterRepository({required this.database});

  Future<void> saveCounter(int value) async {
    await database.saveCounter(value);
  }

  Future<int> getCounter() async {
    final value = await database.getCounter();
    return value ?? 0;
  }
}
