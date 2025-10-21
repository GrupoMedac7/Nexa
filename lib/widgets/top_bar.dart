import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';
import 'package:nexa/widgets/theme_switch.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  bool shouldShowBack(String? route) {
    const blockedRoutes = ['/', '/login', '/signin'];
    return route != null && !blockedRoutes.contains(route);
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Cerrar sesión"),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: shouldShowBack(currentRoute)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      backgroundColor: Colors.transparent,
      title: RichText(
        text: TextSpan(
          text: 'Ne',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.isDarkMode.value
                ? AppTheme.palette['white']
                : AppTheme.palette['black'],
          ),
          children: [
            TextSpan(
              text: 'Xa',
              style: TextStyle(
                color: AppTheme.isDarkMode.value
                    ? AppTheme.palette['white']
                    : AppTheme.palette['dark_purple'],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ThemeSwitch(),
        IconButton(
          icon: const Icon(Icons.power_settings_new_outlined),
          onPressed: () => onLogoutPressed(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
