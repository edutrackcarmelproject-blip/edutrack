import 'package:flutter/material.dart';
import 'theme_controller.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (_, isDark, __) {
        return GestureDetector(
          onTap: ThemeController.toggleTheme,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60,
            height: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.grey[800] : Colors.grey[300],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: isDark ? 30 : 0,
                  right: isDark ? 0 : 30,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.yellow : Colors.indigo,
                    ),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 16,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
