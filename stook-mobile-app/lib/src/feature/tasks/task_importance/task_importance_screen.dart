import 'package:flutter/material.dart';

/// Экран важности задачи.
class TaskImportanceScreen extends StatelessWidget {
  const TaskImportanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: const Center(
        child: Text('Task importance screen'),
      ),
    );
  }
}
