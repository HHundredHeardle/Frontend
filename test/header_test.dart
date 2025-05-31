/// Hottest Hundred Heardle
/// header_test.dart
///
/// Tests for header
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:hottest_hundred_heardle/header.dart';

void main() {
  group("Header widget tests", () {
    const HHHeader header = HHHeader();
    const Widget widget = MaterialApp(
      home: Scaffold(
        body: header,
      ),
    );

    testWidgets("Title is correct", (WidgetTester tester) async {
      await tester.pumpWidget(widget);

      expect(find.text("Hottest Hundred Heardle"), findsOneWidget);
    });

    testWidgets("Header has correct height", (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      Size widgetSize = tester.getSize(find.byWidget(header));
      expect(widgetSize.height, 50.0);
    });
  });

  testWidgets("Header golden test", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: "monospace"),
        home: Scaffold(
          body: HHHeader(),
        ),
      ),
    );

    await expectLater(
      find.byType(HHHeader),
      matchesGoldenFile('goldens/HHHeader.png'),
    );
  });
}
