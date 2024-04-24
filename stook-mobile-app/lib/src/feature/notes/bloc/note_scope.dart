import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stook_database/database_context.dart';

import 'note_bloc.dart';

/// Область видимости блока заметок.
abstract class NoteScope {
  /// Получить блок.
  static INoteBloc of(BuildContext context) {
    return BlocProvider.of<INoteBloc>(context);
  }

  /// Загрузить данные.
  static void load(BuildContext context) {
    of(context).add(const NoteEvent.load());
  }

  /// Добавить/изменить заметку.
  static void putNote(
    BuildContext context, {
    int? noteId,
    int fromScreenIndex = 0,
  }) {
    of(context).add(NoteEvent.putNote(
      noteId: noteId,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Удалить заметку.
  static void deleteNote(
    BuildContext context, {
    required int noteId,
    int fromScreenIndex = 0,
  }) {
    of(context).add(NoteEvent.deleteNote(
      noteId: noteId,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Сохранить добавленную/измененную заметку.
  static void savePuttedNote(
    BuildContext context, {
    required Note note,
    int fromScreenIndex = 0,
  }) {
    of(context).add(NoteEvent.savePuttedNote(
      note: note,
      fromScreenIndex: fromScreenIndex,
    ));
  }
}
