/// Hottest Hundred Heardle
/// footer_test.dart
///
/// Tests for footer
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hottest_hundred_heardle/footer.dart';

void main() {
  testWidgets("Version placeholder is displayed", (WidgetTester tester) async {
    // Build widget and trigger frame
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HHFooter(),
        ),
      ),
    );

    // verify that version text is correct
    expect(find.text("debug"), findsOneWidget);
  });
}
