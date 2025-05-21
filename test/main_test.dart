/// Hottest Hundred Heardle
/// main_test.dart
///
/// Tests for main screen
///
/// Authors: Joshua Linehan
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:hottest_hundred_heardle/main.dart';

void main() {
  testWidgets("Title is displayed", (WidgetTester tester) async {
    // Build app and trigger frame
    await tester.pumpWidget(const HHundredHeardle());

    // verify that title exists
    expect(find.text("Hottest Hundred Heardle"), findsOneWidget);
  });
}
