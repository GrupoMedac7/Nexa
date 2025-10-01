import 'package:flutter/material.dart';
import 'package:nexa/core/theme_provider.dart';

class OptionsMenu extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback? onSignOut; // <-- define the callback here

  const OptionsMenu({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    this.onSignOut, // <-- accept it in the constructor
  });

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dark Mode'),
              ValueListenableBuilder<bool>(
                valueListenable: AppTheme.isDarkMode,
                builder: (context, isDark, _) {
                  return Switch(
                    value: isDark,
                    onChanged: (_) => widget.onToggleTheme(),
                  );
                },
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          onTap: widget.onSignOut, // <-- use the callback
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
