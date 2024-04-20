import 'package:flutter/material.dart';

import '../themes/theme_colors.dart';
import '../themes/theme_extention.dart';

/// Компонент таб-бар
class ThesisTabBar extends StatelessWidget {
  const ThesisTabBar({
    super.key,
    required this.tabs,
    required this.children,
    this.onTap,
  });

  final List<String> tabs;
  final List<Widget> children;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final pickedNotifier = ValueNotifier<int>(0);
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
                  children: List.generate(tabs.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index != tabs.length - 1 ? 8 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          pickedNotifier.value = index;
                          onTap?.call(index);
                        },
                        child: _ThesisTabBarItem(
                          title: tabs[index],
                          isPicked: currentIndex == index,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            children[currentIndex],
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
        color: isPicked
            ? kPrimaryLighterColor
            : context.currentTheme.cardTheme.color,
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
