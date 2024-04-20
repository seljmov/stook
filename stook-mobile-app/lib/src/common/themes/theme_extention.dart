import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'theme_colors.dart';

/// Расширение контекста для работы с темой
extension CurrentTheme on BuildContext {
  AdaptiveThemeManager<ThemeData> get _manager => AdaptiveTheme.of(this);

  /// Получить текущую темы
  ThemeData get currentTheme => _manager.theme;

  /// Получить тему текста
  TextTheme get textTheme => currentTheme.textTheme;

  /// Получить основной цвет текста
  Color get textPrimaryColor =>
      isDarkMode ? kDarkTextPrimaryColor : kLightTextPrimaryColor;

  /// Получить вторичный цвет текста
  Color get textSecondaryColor =>
      isDarkMode ? kDarkTextSecondaryColor : kLightTextSecondaryColor;

  /// Получить текущий режим
  AdaptiveThemeMode get currentMode => _manager.mode;

  /// Проверка на темную тему
  bool get isDarkMode => currentMode == AdaptiveThemeMode.dark;
}
