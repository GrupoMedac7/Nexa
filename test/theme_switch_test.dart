import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexa/core/themes.dart';
import 'package:nexa/widgets/theme_switch.dart';

void main() {
  testWidgets(
    'ThemeSwitch displays and toggles the app theme correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppTheme.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ThemeSwitch(),
                );
              },
            ),
          ),
        ),
      );

      expect(AppTheme.isDarkMode.value, false);
      expect(find.byType(Switch), findsOneWidget);
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(AppTheme.isDarkMode.value, true);
      final switchedWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchedWidget.value, true);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(AppTheme.isDarkMode.value, false);
      final switchedBackWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchedBackWidget.value, false);
    },
  );
}