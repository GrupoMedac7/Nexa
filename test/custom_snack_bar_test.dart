import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexa/widgets/custom_snack_bar.dart'; // adjust import as needed

void main() {
  final testCases = [
    {
      'mode': CustomSnackBarMode.def,
      'message': 'Default message',
      'icon': Icons.info_outline,
      'color': Colors.blueGrey,
    },
    {
      'mode': CustomSnackBarMode.succ,
      'message': 'Success message',
      'icon': Icons.check_outlined,
      'color': Colors.green,
    },
    {
      'mode': CustomSnackBarMode.err,
      'message': 'Error message',
      'icon': Icons.error_outline,
      'color': Colors.redAccent,
    },
  ];

  for (final caseData in testCases) {
    final testCase = Map<String, dynamic>.from(caseData);
    testWidgets(
      'CustomSnackBar shows correct message, icon, and color for ${testCase['mode']}',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        CustomSnackBar.show(
                          context,
                          testCase['message'] as String,
                          mode: testCase['mode'] as CustomSnackBarMode,
                        );
                      },
                      child: const Text('Show SnackBar'),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pump();

        expect(find.text(testCase['message'] as String), findsOneWidget);
        expect(find.byIcon(testCase['icon'] as IconData), findsOneWidget);

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, testCase['color']);

        await tester.pumpAndSettle();
      },
    );
  }
}
