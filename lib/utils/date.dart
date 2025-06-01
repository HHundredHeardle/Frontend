/// Hottest Hundred Heardle
/// date.dart
///
/// Provides uniform access to date
///
/// Authors: Joshua Linehan
library;

import 'package:instant/instant.dart';

/// Singleton access to uniform date
class HHDate {
  final DateTime date = dateTimeToZone(zone: "AEST", datetime: DateTime.now());

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
