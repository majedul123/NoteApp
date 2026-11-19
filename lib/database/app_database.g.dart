// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CounterTableTable extends CounterTable
    with TableInfo<$CounterTableTable, CounterTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CounterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counter_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CounterTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CounterTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CounterTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $CounterTableTable createAlias(String alias) {
    return $CounterTableTable(attachedDatabase, alias);
  }
}

class CounterTableData extends DataClass
    implements Insertable<CounterTableData> {
  final int id;
  final int value;
  const CounterTableData({required this.id, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['value'] = Variable<int>(value);
    return map;
  }

  CounterTableCompanion toCompanion(bool nullToAbsent) {
    return CounterTableCompanion(id: Value(id), value: Value(value));
  }

  factory CounterTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CounterTableData(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<int>(value),
    };
  }

  CounterTableData copyWith({int? id, int? value}) =>
      CounterTableData(id: id ?? this.id, value: value ?? this.value);
  CounterTableData copyWithCompanion(CounterTableCompanion data) {
    return CounterTableData(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CounterTableData(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CounterTableData &&
          other.id == this.id &&
          other.value == this.value);
}

class CounterTableCompanion extends UpdateCompanion<CounterTableData> {
  final Value<int> id;
  final Value<int> value;
  const CounterTableCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
  });
  CounterTableCompanion.insert({
    this.id = const Value.absent(),
    required int value,
  }) : value = Value(value);
  static Insertable<CounterTableData> custom({
    Expression<int>? id,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
    });
  }

  CounterTableCompanion copyWith({Value<int>? id, Value<int>? value}) {
    return CounterTableCompanion(id: id ?? this.id, value: value ?? this.value);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CounterTableCompanion(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CounterTableTable counterTable = $CounterTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [counterTable];
}

typedef $$CounterTableTableCreateCompanionBuilder =
    CounterTableCompanion Function({Value<int> id, required int value});
typedef $$CounterTableTableUpdateCompanionBuilder =
    CounterTableCompanion Function({Value<int> id, Value<int> value});

class $$CounterTableTableFilterComposer
    extends Composer<_$AppDatabase, $CounterTableTable> {
  $$CounterTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CounterTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CounterTableTable> {
  $$CounterTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CounterTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CounterTableTable> {
  $$CounterTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$CounterTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CounterTableTable,
          CounterTableData,
          $$CounterTableTableFilterComposer,
          $$CounterTableTableOrderingComposer,
          $$CounterTableTableAnnotationComposer,
          $$CounterTableTableCreateCompanionBuilder,
          $$CounterTableTableUpdateCompanionBuilder,
          (
            CounterTableData,
            BaseReferences<_$AppDatabase, $CounterTableTable, CounterTableData>,
          ),
          CounterTableData,
          PrefetchHooks Function()
        > {
  $$CounterTableTableTableManager(_$AppDatabase db, $CounterTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CounterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CounterTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CounterTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> value = const Value.absent(),
          }) => CounterTableCompanion(id: id, value: value),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int value,
          }) => CounterTableCompanion.insert(id: id, value: value),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CounterTableTable, CounterTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CounterTableTable,
                    CounterTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CounterTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CounterTableTable,
      CounterTableData,
      $$CounterTableTableFilterComposer,
      $$CounterTableTableOrderingComposer,
      $$CounterTableTableAnnotationComposer,
      $$CounterTableTableCreateCompanionBuilder,
      $$CounterTableTableUpdateCompanionBuilder,
      (
        CounterTableData,
        BaseReferences<_$AppDatabase, $CounterTableTable, CounterTableData>,
      ),
      CounterTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CounterTableTableTableManager get counterTable =>
      $$CounterTableTableTableManager(_db, _db.counterTable);
}
