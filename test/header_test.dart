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
  testWidgets("Title is correct", (WidgetTester tester) async {
    // Build widget and trigger frame
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HHHeader(),
        ),
      ),
    );

    // verify that title exists
    expect(find.text("Hottest Hundred Heardle"), findsOneWidget);
  });
}
