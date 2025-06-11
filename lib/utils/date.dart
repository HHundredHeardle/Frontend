/// Hottest Hundred Heardle
/// date.dart
///
/// Provides uniform access to date
///
/// Authors: Joshua Linehan
library;

import 'package:timezone/browser.dart' as tz;

/// Singleton access to uniform date
class HHDate {
  final Future<DateTime> date = (() async {
    await tz.initializeTimeZone('packages/timezone/data/latest_10y.tzf');
    return tz.TZDateTime.now(tz.getLocation("Australia/Melbourne"));
  })();

  static final _instance = HHDate._internal();

  HHDate._internal();

  factory HHDate() => _instance;

  /// gets the date as a string in the form DD/MM/YYYY
  static String formatted(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// gets the date as a string in the form DD/MM/YYYY for result sharing
  Future<String> resultString() async {
    return formatted(await date);
  }
}
