import 'package:flutter/material.dart';

import '../themes/theme_colors.dart';
import '../themes/theme_extention.dart';

/// Компонент таб-бар
class ThesisTabBar extends StatefulWidget {
  const ThesisTabBar({
    super.key,
    required this.tabs,
    required this.children,
    this.initialScreenIndex = 0,
    this.onTap,
  });

  final List<String> tabs;
  final List<Widget> children;
  final int initialScreenIndex;
  final void Function(int)? onTap;

  @override
  State<ThesisTabBar> createState() => _ThesisTabBarState();
}

class _ThesisTabBarState extends State<ThesisTabBar> {
  final pickedNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    pickedNotifier.value = widget.initialScreenIndex;
    super.initState();
  }

  @override
  void dispose() {
    pickedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pickedNotifier,
      builder: (context, currentIndex, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(widget.tabs.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index != widget.tabs.length - 1 ? 8 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          pickedNotifier.value = index;
                          widget.onTap?.call(index);
                        },
                        child: _ThesisTabBarItem(
                          title: widget.tabs[index],
                          isPicked: currentIndex == index,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            widget.children[currentIndex],
          ],
        );
      },
    );
  }
}

/// Элемент таб-бара
class _ThesisTabBarItem extends StatelessWidget {
  const _ThesisTabBarItem({
    required this.title,
    required this.isPicked,
  });

  final String title;
  final bool isPicked;

  @override
  Widget build(BuildContext context) {
    final titlePickedStyle = context.textTheme.titleMedium!.copyWith(
      color: kDarkTextPrimaryColor,
    );
    final titleStyle = titlePickedStyle.copyWith(
      color: context.isDarkMode
          ? kDarkTextSecondaryColor
          : kLightTextSecondaryColor,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            isPicked ? Colors.deepPurple : context.currentTheme.cardTheme.color,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        child: Text(
          title,
          style: isPicked ? titlePickedStyle : titleStyle,
        ),
      ),
    );
  }
}
