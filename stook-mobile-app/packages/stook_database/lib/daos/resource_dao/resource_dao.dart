import 'package:drift/drift.dart';
import 'package:stook_database/models/resource.dart';

import '../../database_context.dart';

part 'resource_dao.g.dart';

/// DAO для работы с заметками.
@DriftAccessor(tables: [Resources])
class ResourceDao extends DatabaseAccessor<DatabaseContext>
    with _$ResourceDaoMixin {
  ResourceDao(super.db);

  /// Получить все заметки.
  Future<List<Resource>> getAll() => select(resources).get();

  /// Получить заметку по идентификатору.
  Future<Resource?> getById(int id) =>
      (select(resources)..where((n) => n.id.equals(id))).getSingleOrNull();

  /// Вставить заметку.
  Future<int> insert(ResourcesCompanion resource) =>
      into(resources).insert(resource);

  /// Обновить заметку.
  Future updateResource(Resource resource) =>
      update(resources).replace(resource);

  /// Удалить заметку.
  Future deleteResource(Resource resource) =>
      delete(resources).delete(resource);

  /// Удалить все заметки.
  Future deleteAll() => delete(resources).go();
}
