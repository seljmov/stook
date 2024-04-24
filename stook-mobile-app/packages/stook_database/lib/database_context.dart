library stook_database;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'daos/lesson_dao/lesson_dao.dart';
import 'daos/note_dao/note_dao.dart';
import 'daos/resource_dao/resource_dao.dart';
import 'daos/task_dao/task_dao.dart';
import 'daos/task_depend_on_relation_dao/task_depend_on_relation_dao.dart';
import 'daos/task_subtask_relation_dao/task_subtask_relation_dao.dart';

import 'models/models.dart';

part 'database_context.g.dart';

/// Контекст базы данных.
@DriftDatabase(
  tables: [
    Lessons,
    Tasks,
    Resources,
    Notes,
    Schedules,
    TaskSubtaskRelations,
    TaskDependOnRelations,
  ],
  daos: [
    LessonsDao,
    TasksDao,
    NoteDao,
    ResourceDao,
    TaskSubtaskRelationsDao,
    TaskDependOnRelationsDao,
  ],
)
class DatabaseContext extends _$DatabaseContext {
  DatabaseContext() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.alterTable(TableMigration(tasks));
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
