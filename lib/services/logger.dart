import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';

class Logger {
  static void log(String message) {
    if (kDebugMode) {
      print('[LOG]: $message');
    }
  }

  static void error(String message, [StackTrace? stacktrace]) {
    if (kDebugMode) {
      print('[ERROR]: $message');
      if (stacktrace != null) {
        print(stacktrace);
      }
    }
  }

  static void showError(BuildContext context, String message) {
    if (kDebugMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: AppTheme.palette['white']),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3)
        ),
      );
    }
  }
}
