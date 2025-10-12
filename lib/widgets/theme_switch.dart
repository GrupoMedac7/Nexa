import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkMode,
      builder: (context, isDark, _) {
        return Switch(
          value: isDark,
          onChanged: (_) => AppTheme.toggleTheme(),
        );
      },
    );
  }
}
