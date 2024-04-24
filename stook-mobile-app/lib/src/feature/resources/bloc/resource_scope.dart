import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stook_database/database_context.dart';

import 'resource_bloc.dart';

/// Область видимости блока ресурсов.
abstract class ResourceScope {
  /// Получить блок.
  static IResourceBloc of(BuildContext context) {
    return BlocProvider.of<IResourceBloc>(context);
  }

  /// Загрузить данные.
  static void load(BuildContext context) {
    of(context).add(const ResourceEvent.load());
  }

  /// Добавить/изменить ресурс.
  static void putResource(
    BuildContext context, {
    int? resourceId,
    int fromScreenIndex = 0,
  }) {
    of(context).add(ResourceEvent.putResource(
      resourceId: resourceId,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Удалить ресурс.
  static void deleteResource(
    BuildContext context, {
    required int resourceId,
    int fromScreenIndex = 0,
  }) {
    of(context).add(ResourceEvent.deleteResource(
      resourceId: resourceId,
      fromScreenIndex: fromScreenIndex,
    ));
  }

  /// Сохранить добавленный/измененный ресурс.
  static void savePuttedResource(
    BuildContext context, {
    required Resource resource,
    int fromScreenIndex = 0,
  }) {
    of(context).add(ResourceEvent.savePuttedResource(
      resource: resource,
      fromScreenIndex: fromScreenIndex,
    ));
  }
}
