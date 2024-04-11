import 'package:flutter/material.dart';

import 'src/common/infrastructure/di_configurator.dart';
import 'src/common/widget/app.dart';

/// Точка входа в приложение.
void main() {
  DiConfigurator.configure();
  runApp(const MyApp());
}

/// Главный виджет приложения.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stook Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}
