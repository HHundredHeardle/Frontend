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
  group("Footer widget tests", () {
    const HHFooter footer = HHFooter();
    const Widget widget = MaterialApp(
      home: Scaffold(
        body: footer,
      ),
    );

    testWidgets("Footer is displayed", (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.byWidget(footer), findsOneWidget);
    });

    testWidgets("Footer contains appropriate text",
        (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.text("Contact: "), findsOneWidget);
      expect(find.text("hhundredheardle@gmail.com"), findsOneWidget);
      expect(find.text("debug"), findsOneWidget);
    });

    testWidgets("Footer has correct size", (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      Size widgetSize = tester.getSize(find.byWidget(footer));
      expect(widgetSize.height, 40.0);
    });
  });

  testWidgets("Footer golden test", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HHFooter(),
        ),
      ),
    );

    await expectLater(
      find.byType(HHFooter),
      matchesGoldenFile('goldens/HHFooter.png'),
    );
  });
}
