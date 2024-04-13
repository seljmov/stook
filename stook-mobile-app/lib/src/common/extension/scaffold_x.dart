import 'package:flutter/material.dart';

/// Расширение для Scaffold.
extension ScaffoldX on Scaffold {
  /// Добавляет отступ снизу.
  Scaffold withBottomPadding() {
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: body,
      ),
    );
  }
}
