/// Hottest Hundred Heardle
/// date.dart
///
/// Provides uniform access to date
///
/// Authors: Joshua Linehan
library;

import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Singleton access to uniform date
class HHDate {
  bool tzInitialized = false;

  DateTime get date {
    try {
      if (!tzInitialized) {
        tz.initializeTimeZones();
        tzInitialized = true;
      }
      return tz.TZDateTime.now(tz.getLocation("Australia/Melbourne"));
    } catch (e) {
      return DateTime.now();
    }
  }

  static final _instance = HHDate._internal();

  HHDate._internal();

  factory HHDate() => _instance;

  /// gets the date as a string in the form DD/MM/YYYY
  static String formatted(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// gets the date as a string in the form DD/MM/YYYY for result sharing
  String resultString() {
    return formatted(date);
  }
}
