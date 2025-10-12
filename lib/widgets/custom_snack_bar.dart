import 'package:flutter/material.dart';

enum CustomSnackBarMode { def, succ, err }

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message, {
    CustomSnackBarMode mode = CustomSnackBarMode.def,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color backgroundColor = switch (mode) {
      CustomSnackBarMode.def => Colors.blueGrey,
      CustomSnackBarMode.succ => Colors.green,
      CustomSnackBarMode.err => Colors.redAccent,
    };

    final IconData icon = switch (mode) {
      CustomSnackBarMode.def => Icons.info_outline,
      CustomSnackBarMode.succ => Icons.check_outlined,
      CustomSnackBarMode.err => Icons.error_outline,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}