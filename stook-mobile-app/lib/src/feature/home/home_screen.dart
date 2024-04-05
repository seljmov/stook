import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

import '../../common/router/routes.dart';

/// Страница домашнего экрана.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.octopus.push(Routes.schedulePut),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
