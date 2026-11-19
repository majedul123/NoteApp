import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class CounterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get value => integer()();
}

@DriftDatabase(tables: [CounterTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> saveCounter(int value) async {
    await delete(counterTable).go();
    await into(counterTable).insert(
      CounterTableCompanion(value: Value(value)),
    );
  }

  Future<int?> getCounter() async {
    final result = await select(counterTable).getSingleOrNull();
    return result?.value;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
