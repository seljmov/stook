import 'package:flutter/material.dart';

import '../calendar/calendar_screen.dart';
import '../notes/notes_screen.dart';
import '../resources/resources_screen.dart';
import '../tasks/tasks_wrapper_screen.dart';

/// Страница домашнего экрана.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<_NavBarItem> screens = const [
    _NavBarItem(
      screen: CalendarScreen(),
      item: BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Расписание',
      ),
    ),
    _NavBarItem(
      screen: TasksWrapperScreen(),
      item: BottomNavigationBarItem(
        icon: Icon(Icons.check),
        label: 'Задачи',
      ),
    ),
    _NavBarItem(
      screen: NotesScreen(),
      item: BottomNavigationBarItem(
        icon: Icon(Icons.note),
        label: 'Заметки',
      ),
    ),
    _NavBarItem(
      screen: ResourcesScreen(),
      item: BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Ресурсы',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedScreenNotifier = ValueNotifier<int>(3);
    return ValueListenableBuilder<int>(
      valueListenable: selectedScreenNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: null,
          body: screens[selectedPage].screen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedPage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor:
                Theme.of(context).colorScheme.outline.withOpacity(0.25),
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            elevation: 0,
            onTap: (index) => selectedScreenNotifier.value = index,
            items: List.generate(
              screens.length,
              (index) => BottomNavigationBarItem(
                icon: screens[index].item.icon,
                label: screens[index].item.label,
              ),
            ),
          ),
        );
      },
    );
  }
}

///
class _NavBarItem {
  final Widget screen;
  final BottomNavigationBarItem item;

  const _NavBarItem({required this.screen, required this.item});
}
