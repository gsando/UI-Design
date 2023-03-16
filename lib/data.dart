// import 'dart:collection';

import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'data.g.dart';

class Exercise extends Table {
  //exercise table with default values of 0 for the minutes/ seconds
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().named('body')();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get seconds => integer().withDefault(const Constant(0))();
}

class PlanEx extends Table {
  //drift does not recognize List as a datatype, so it has no column >:(
  IntColumn get id => integer().autoIncrement()(); //nodeID
  IntColumn get planID =>
      integer()(); //a single plan will have an ID, exercises belonging to that plan will share planID
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().named('body')();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get seconds => integer().withDefault(const Constant(0))();
}

class PlanName extends Table {
  IntColumn get planID => integer().autoIncrement()();
  TextColumn get titlePlan => text().withLength(min: 1, max: 100)();
}

@DriftDatabase(tables: [Exercise, PlanEx, PlanName])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.createTable(planName);
          await m.createTable(planEx);
        }
        // if (from < 3) {
        //   // we added the priority property in the change from version 1 or 2
        //   // to version 3
        //   await m.addColumn(todos, todos.priority);
        // }
      },
    );
  }

  Future<List<PlanExData>> getPlanEx(int planID) async {
    return await (select(planEx)..where((tbl) => tbl.planID.equals(planID)))
        .get();
  }

  Future<PlanNameData> getPlanName(int planID) async {
    return await (select(planName)..where((tbl) => tbl.planID.equals(planID)))
        .getSingle();
  }

  Future<List<PlanNameData>> getAllPlanNames() async {
    return await select(planName).get();
  }

  //Gets the entire list of exercises
  Future<List<ExerciseData>> getExercises() async {
    return await select(exercise).get();
  }

  Future<ExerciseData> getExercise(int id) async {
    return await (select(exercise)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<bool> updateEx(ExerciseCompanion entity) async {
    return await update(exercise).replace(entity);
  }

  Future<int> insertExercise(ExerciseCompanion entity) async {
    return await into(exercise).insert(entity);
  }

  Future<int> deleteExercise(int id) async {
    return await (delete(exercise)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
