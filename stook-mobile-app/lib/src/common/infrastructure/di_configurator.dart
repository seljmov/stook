import 'package:injector/injector.dart';
import 'package:stook_database/database_context.dart';

/// Глобальный инжектор.
final injector = Injector.appInstance;

/// Конфигуратор для внедрения зависимостей.
class DiConfigurator {
  /// Конфигурирует инжектор.
  static void configure() {
    injector.registerSingleton<DatabaseContext>(() => DatabaseContext());
  }
}
