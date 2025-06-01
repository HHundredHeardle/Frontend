/// Hottest Hundred Heardle
/// local_storage.dart
///
/// Handles storing local data: state management, streaks, and longest streaks
///
/// Authors: Joshua Linehan
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'date.dart';
import 'game_controller.dart';

/// Singleton that handles storing and retrieving local data
class LocalStorage {
  static const String _longestStreakKey = "longest_streak";
  static const String _streakKey = "streak";
  static const String _guessesKey = "guesses";

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  final Completer<List<Guess>> _guesses = Completer<List<Guess>>();
  final Completer<int> _streak = Completer<int>();
  final Completer<int> _longestStreak = Completer<int>();

  Future<List<Guess>> get guesses => _guesses.future;
  Future<int> get streak => _streak.future;
  Future<int> get longestStreak => _longestStreak.future;

  static final LocalStorage _instance = LocalStorage._internal();

  LocalStorage._internal() {
    // load guesses
    _getGuesses().then((value) {
      List<Guess> guesses = [];
      if (value == null) {
        return guesses;
      }
      dynamic guessJson = jsonDecode(value);
      for (String guessString in guessJson[HHDate.formatted(HHDate().date)]) {
        guesses.add(Guess.fromString(guessString));
      }
      return guesses;
    }).then((value) {
      _guesses.complete(value);
    }).onError(
      (error, stackTrace) {
        _guesses.complete([]);
      },
    );

    // add guess event listener
    GameController().guessMade.subscribe(() async {
      // build list of guess strings
      GameController gameController = GameController();
      int guesses = gameController.numGuesses();
      List<String> guessStrings = [];
      for (int i = 0; i < guesses; i++) {
        guessStrings.add((await gameController.getGuess(i + 1)).toString());
      }

      // save json of guesses
      Map<String, List<String>> guessMap = {};
      guessMap[HHDate.formatted(HHDate().date)] = guessStrings;
      _setGuesses(jsonEncode(guessMap));
    });

    // update streaks when done
    GameController().result.then((value) => _saveStreaks(value));
  }

  factory LocalStorage() => _instance;

  /// gets stored streak
  Future<List<String>?> _getStreak() async {
    return _preferences.getStringList(_streakKey);
  }

  /// stores streak
  Future<void> _setStreak(List<String> value) async {
    _preferences.setStringList(_streakKey, value);
  }

  /// gets stored longest streak
  Future<int?> _getLongestStreak() async {
    return _preferences.getInt(_longestStreakKey);
  }

  /// stores longest streak
  Future<void> _setLongestStreak(int value) async {
    _preferences.setInt(_longestStreakKey, value);
  }

  /// gets stored guesses
  Future<String?> _getGuesses() async {
    return _preferences.getString(_guessesKey);
  }

  /// stores guesses
  Future<void> _setGuesses(String value) async {
    _preferences.setString(_guessesKey, value);
  }

  /// save new streaks
  void _saveStreaks(Result result) async {
    int streak;
    int longest = (await _getLongestStreak()) ?? 0;

    switch (result) {
      case Result.lose:
        _setStreak([]);
        streak = 0;
        break;
      case Result.win:
        List<String> streakList = (await _getStreak()) ?? [];
        streakList.add(HHDate.formatted(HHDate().date));
        streak = _countStreak(streakList);
        streakList = streakList.sublist(streakList.length - streak);
        _setStreak(streakList);
        break;
    }

    longest = max(longest, streak);
    _setLongestStreak(longest);

    _streak.complete(streak);
    _longestStreak.complete(longest);
  }

  /// counts a streak from a list of date string
  int _countStreak(List<String> streak) {
    DateTime date = HHDate().date;
    int count = 0;
    int i = streak.length - 1;
    while (i >= 0) {
      if (streak[i] == HHDate.formatted(date)) {
        count++;
      } else {
        break;
      }
      date = date.subtract(Duration(days: 1));
      i--;
    }
    return count;
  }
}
