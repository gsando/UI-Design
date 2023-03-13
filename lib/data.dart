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

class Plan extends Table {
  //drift does not recognize List as a datatype, so it has no column >:(
  IntColumn get id => integer().autoIncrement()(); //nodeID
  IntColumn get planID => integer()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().named('body')();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get seconds => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Exercise, Plan])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

  // Future<List<ExerciseData>> getPlan(int id) async {
  //   return await select(exercise)
  //     ..where((tbl) => tbl.id.equals());
  // }

  // void addToPlan(Exercise exercise, int planId) async {
  //   Plan randHold = (select(plan)..where((tbl) => tbl.id.equals(planId)))
  //       .getSingle() as Plan;
  //   List<Exercise> holder = randHold.rand;
  //   holder.add(exercise);
  //   final entity = PlanCompanion(id: Value(planId));

  //   // update(plan).replace(randHold);
  // }

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
