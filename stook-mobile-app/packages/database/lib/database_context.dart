import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'daos/lesson_dao.dart';
import 'models/enums/day_of_week.dart';
import 'models/enums/lesson_type.dart';
import 'models/enums/resource_type.dart';
import 'models/enums/task_priority.dart';
import 'models/lesson.dart';
import 'models/note.dart';
import 'models/resource.dart';
import 'models/schedule.dart';
import 'models/task.dart';

part 'database_context.g.dart';

/// Контекст базы данных.
@DriftDatabase(
  tables: [Lessons, Tasks, Resources, Notes, Schedules],
  daos: [LessonsDao],
)
class DatabaseContext extends _$DatabaseContext {
  DatabaseContext() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {},
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
