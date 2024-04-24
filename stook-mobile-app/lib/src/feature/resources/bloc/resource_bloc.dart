import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stook_database/database_context.dart';

part 'resource_bloc.freezed.dart';

/// Интерфейс блока заметок.
abstract class IResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  IResourceBloc() : super(const ResourceState.loaderShow());
}

/// Блок заметок.
class ResourceBloc extends IResourceBloc {
  final DatabaseContext _databaseContext;

  ResourceBloc({
    required DatabaseContext databaseContext,
  }) : _databaseContext = databaseContext {
    on<ResourceEvent>(
      (event, emit) => event.map(
        load: (event) => _load(event, emit),
        putResource: (event) => _putResource(event, emit),
        deleteResource: (event) => _deleteResource(event, emit),
        savePuttedResource: (event) => _savePuttedResource(event, emit),
      ),
    );
  }

  Future<void> _load(_Load event, Emitter<ResourceState> emit) async {
    emit(const ResourceState.loaderShow());
    final resources = await _databaseContext.resourceDao.getAll();
    emit(const ResourceState.loaderHide());
    emit(ResourceState.loaded(resources: resources));
  }

  Future<void> _putResource(
      _PutResource event, Emitter<ResourceState> emit) async {
    emit(const ResourceState.loaderShow());
    if (event.resourceId == null) {
      emit(const ResourceState.loaderHide());
      emit(const ResourceState.openPutResourceScreen(resource: null));
      return;
    }
    final resource =
        await _databaseContext.resourceDao.getById(event.resourceId!);
    emit(const ResourceState.loaderHide());
    emit(ResourceState.openPutResourceScreen(resource: resource));
  }

  Future<void> _deleteResource(
      _DeleteResource event, Emitter<ResourceState> emit) async {
    emit(const ResourceState.loaderShow());
    final resource =
        await _databaseContext.resourceDao.getById(event.resourceId);
    if (resource != null) {
      await _databaseContext.resourceDao.deleteResource(resource);
    }
    final resources = await _databaseContext.resourceDao.getAll();
    emit(const ResourceState.loaderHide());
    emit(ResourceState.loaded(resources: resources));
  }

  Future<void> _savePuttedResource(
    _SavePuttedResource event,
    Emitter<ResourceState> emit,
  ) async {
    emit(const ResourceState.loaderShow());
    final existed =
        await _databaseContext.resourceDao.getById(event.resource.id);
    if (existed != null) {
      await _databaseContext.resourceDao.updateResource(event.resource);
    } else {
      await _databaseContext.resourceDao
          .insert(event.resource.toCompanion(false));
    }
    final resources = await _databaseContext.resourceDao.getAll();
    emit(const ResourceState.loaderHide());
    emit(ResourceState.loaded(resources: resources));
  }
}

/// События блока заметок.
@freezed
abstract class ResourceEvent with _$ResourceEvent {
  /// Загрузить заметки.
  const factory ResourceEvent.load() = _Load;

  /// Добавить/изменить заметку.
  const factory ResourceEvent.putResource({
    required int? resourceId,
    required int fromScreenIndex,
  }) = _PutResource;

  /// Удалить заметку.
  const factory ResourceEvent.deleteResource({
    required int resourceId,
    required int fromScreenIndex,
  }) = _DeleteResource;

  /// Сохранить добавленную/измененную заметку.
  const factory ResourceEvent.savePuttedResource({
    required Resource resource,
    required int fromScreenIndex,
  }) = _SavePuttedResource;
}

/// Состояния блока заметок.
@freezed
abstract class ResourceState with _$ResourceState {
  /// Показать загрузчик.
  const factory ResourceState.loaderShow() = _ResourceLoaderShowState;

  /// Скрыть загрузчик.
  const factory ResourceState.loaderHide() = _ResourceLoaderHideState;

  /// Загружены заметки.
  const factory ResourceState.loaded({
    required List<Resource> resources,
  }) = _LoadedState;

  /// Заметка добавлена/изменена.
  const factory ResourceState.openPutResourceScreen({
    required Resource? resource,
  }) = _ResourceOpenedPutScreen;
}
