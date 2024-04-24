import 'package:drift/drift.dart';
import 'package:stook_database/models/note.dart';

import '../../database_context.dart';

part 'note_dao.g.dart';

/// DAO для работы с заметками.
@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<DatabaseContext> with _$NoteDaoMixin {
  NoteDao(super.db);

  /// Получить все заметки.
  Future<List<Note>> getAll() => select(notes).get();

  /// Получить заметку по идентификатору.
  Future<Note?> getById(int id) =>
      (select(notes)..where((n) => n.id.equals(id))).getSingleOrNull();

  /// Вставить заметку.
  Future<int> insert(NotesCompanion note) => into(notes).insert(note);

  /// Обновить заметку.
  Future updateNote(Note note) => update(notes).replace(note);

  /// Удалить заметку.
  Future deleteNote(Note note) => delete(notes).delete(note);

  /// Удалить все заметки.
  Future deleteAll() => delete(notes).go();
}
