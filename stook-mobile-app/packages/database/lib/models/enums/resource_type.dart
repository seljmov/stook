/// Тип ресурса.
enum ResourceType {
  /// Статья.
  article,

  /// Видео.
  video,

  /// Ссылка.
  link,

  // Другое.
  other,
}

/// Расширение для типа ресурса.
extension ResourceTypeExtension on ResourceType {
  /// Возвращает строковое представление типа ресурса.
  String get name {
    switch (this) {
      case ResourceType.article:
        return 'Статья';
      case ResourceType.video:
        return 'Видео';
      case ResourceType.link:
        return 'Ссылка';
      case ResourceType.other:
        return 'Другое';
      default:
        throw ArgumentError('Unknown resource type: $this');
    }
  }
}
