import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stook_database/database_context.dart';

part 'note_bloc.freezed.dart';

/// Интерфейс блока заметок.
abstract class INoteBloc extends Bloc<NoteEvent, NoteState> {
  INoteBloc() : super(const NoteState.loaderShow());
}

/// Блок заметок.
class NoteBloc extends INoteBloc {
  final DatabaseContext _databaseContext;

  NoteBloc({
    required DatabaseContext databaseContext,
  }) : _databaseContext = databaseContext {
    on<NoteEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        putNote: (event) => _putNote(event, emit),
        deleteNote: (event) => _deleteNote(event, emit),
        savePuttedNote: (event) => _savePuttedNote(event, emit),
      ),
    );
  }

  Future<void> _load(_Load event, Emitter<NoteState> emit) async {
    emit(const NoteState.loaderShow());
    final notes = await _databaseContext.noteDao.getAll();
    emit(const NoteState.loaderHide());
    emit(NoteState.loaded(notes: notes));
  }

  Future<void> _putNote(_PutNote event, Emitter<NoteState> emit) async {
    emit(const NoteState.loaderShow());
    if (event.noteId == null) {
      emit(const NoteState.loaderHide());
      emit(const NoteState.openPutNoteScreen(note: null));
      return;
    }
    final note = await _databaseContext.noteDao.getById(event.noteId!);
    emit(const NoteState.loaderHide());
    emit(NoteState.openPutNoteScreen(note: note));
  }

  Future<void> _deleteNote(_DeleteNote event, Emitter<NoteState> emit) async {
    emit(const NoteState.loaderShow());
    final note = await _databaseContext.noteDao.getById(event.noteId);
    if (note != null) {
      await _databaseContext.noteDao.deleteNote(note);
    }
    final notes = await _databaseContext.noteDao.getAll();
    emit(const NoteState.loaderHide());
    emit(NoteState.loaded(notes: notes));
  }

  Future<void> _savePuttedNote(
    _SavePuttedNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(const NoteState.loaderShow());
    final existed = await _databaseContext.noteDao.getById(event.note.id);
    if (existed != null) {
      await _databaseContext.noteDao.updateNote(event.note);
    } else {
      await _databaseContext.noteDao.insert(event.note.toCompanion(false));
    }
    final notes = await _databaseContext.noteDao.getAll();
    emit(const NoteState.loaderHide());
    emit(NoteState.loaded(notes: notes));
  }
}

/// События блока заметок.
@freezed
abstract class NoteEvent with _$NoteEvent {
  /// Загрузить заметки.
  const factory NoteEvent.load() = _Load;

  /// Добавить/изменить заметку.
  const factory NoteEvent.putNote({
    required int? noteId,
    required int fromScreenIndex,
  }) = _PutNote;

  /// Удалить заметку.
  const factory NoteEvent.deleteNote({
    required int noteId,
    required int fromScreenIndex,
  }) = _DeleteNote;

  /// Сохранить добавленную/измененную заметку.
  const factory NoteEvent.savePuttedNote({
    required Note note,
    required int fromScreenIndex,
  }) = _SavePuttedNote;
}

/// Состояния блока заметок.
@freezed
abstract class NoteState with _$NoteState {
  /// Показать загрузчик.
  const factory NoteState.loaderShow() = _NoteLoaderShowState;

  /// Скрыть загрузчик.
  const factory NoteState.loaderHide() = _NoteLoaderHideState;

  /// Загружены заметки.
  const factory NoteState.loaded({
    required List<Note> notes,
  }) = _LoadedState;

  /// Заметка добавлена/изменена.
  const factory NoteState.openPutNoteScreen({
    required Note? note,
  }) = _NoteOpenedPutScreen;
}
