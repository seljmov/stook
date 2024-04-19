import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:stook_database/models/task_subtask_relation.dart';

import 'daos/lesson_dao/lesson_dao.dart';
import 'daos/task_dao/task_dao.dart';
import 'daos/task_depend_on_relation_dao/task_depend_on_relation_dao.dart';
import 'daos/task_subtask_relation_dao/task_subtask_relation_dao.dart';
import 'models/enums/day_of_week.dart';
import 'models/enums/lesson_type.dart';
import 'models/enums/resource_type.dart';
import 'models/enums/task_priority.dart';
import 'models/enums/task_status.dart';
import 'models/lesson.dart';
import 'models/note.dart';
import 'models/resource.dart';
import 'models/schedule.dart';
import 'models/task.dart';
import 'models/task_depend_on_relation.dart';

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
    TaskSubtaskRelationsDao,
    TaskDependOnRelationsDao,
  ],
)
class DatabaseContext extends _$DatabaseContext {
  DatabaseContext() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          m.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from == 4) {
            await migrator.addColumn(tasks, tasks.status);
            await migrator.createTable(taskDependOnRelations);
            await migrator.createTable(taskSubtaskRelations);
          }
          if (from == 7) {
            // remove Task table
            await migrator.deleteTable(tasks.actualTableName);
            // create new Task table
            await migrator.createTable(tasks);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    //final cachebase = (await getTemporaryDirectory()).path;
    //sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
