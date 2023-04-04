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
  BoolColumn get selected => boolean().nullable()();
  // IntColumn get intFlag => integer().withDefault(const Constant(0))();
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
  BoolColumn get favorite => boolean().nullable()();
  IntColumn get totMin => integer().withDefault(const Constant(0))();
  IntColumn get totSec => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Exercise, PlanEx, PlanName])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(exercise, exercise.selected);
          await m.createTable(planName);
          // await m.addColumn(planName, planName.favorite);
          await m.createTable(planEx);
        }
        if (from < 4) {
          // we added the priority property in the change from version 1 or 2
          // to version 3
          await m.addColumn(planName, planName.favorite);
        }
        if (from < 5) {
          await m.addColumn(planName, planName.totMin);
          await m.addColumn(planName, planName.totSec);
        }
      },
    );
  }

  Future<PlanNameData> getLastPlanID() {
    return (select(planName)
          ..orderBy([
            (tbl) => OrderingTerm(
                expression: planName.planID, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingle();
  }

  Future<int> insertPlanEx(PlanExCompanion entity) async {
    return await into(planEx).insert(entity);
  }

  Future<int> insertPlanName(PlanNameCompanion entity) async {
    return await into(planName).insert(entity);
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

  Future updatePlanTime(int planID, int min, int sec) async {
    return await (update(planName)..where((tbl) => tbl.planID.equals(planID)))
        .write(PlanNameCompanion(totMin: Value(min), totSec: Value(sec)));
  }

  Future makeFavorite(int planID) async {
    update(planName).write(const PlanNameCompanion(favorite: Value(false)));
    return (update(planName)..where((tbl) => tbl.planID.equals(planID)))
        .write(const PlanNameCompanion(favorite: Value(true)));
  }

  Future<int> insertExercise(ExerciseCompanion entity) async {
    return await into(exercise).insert(entity);
  }

  Future<int> deleteExercise(int id) async {
    return await (delete(exercise)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deletePlan(int planID) async {
    deletePlanEx(planID);
    // await (delete(planEx)..where((tbl) => tbl.planID.equals(planID))).go();
    return await (delete(planName)..where((tbl) => tbl.planID.equals(planID)))
        .go();
  }

  void deletePlanEx(int planID) {
    (delete(planEx)..where((tbl) => tbl.planID.equals(planID))).go();
  }

  Future makeExTrue(int id) async {
    return (update(exercise)..where((tbl) => tbl.id.equals(id)))
        // ..where((tbl) => tbl.selected.equals(false))
        .write(const ExerciseCompanion(
      selected: Value(true),
    ));
  }

  Future makeExFalse(int id) async {
    return (update(exercise)..where((tbl) => tbl.id.equals(id)))
        // ..where((tbl) => tbl.selected.equals(false))
        .write(const ExerciseCompanion(
      selected: Value(false),
    ));
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    // final dbFolder = await getApplicationDocumentsDirectory();
    // final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final file = File(p.join(Directory.current.path, 'db.sqlite'));
    // return NativeDatabase.createInBackground(file, logStatements: true);
    return NativeDatabase.createInBackground(file);
  });
}
