/// Hottest Hundred Heardle
/// game_controller.dart
///
/// Handles game logic and events
///
/// Authors: Joshua Linehan
library;

import "dart:async";

import 'backend.dart';

/// Controls game logic and events
class GameController {
  static const int _maxGuesses = 5;

  final Future<String> _answer = _getAnswer();
  final Completer<Result> _resultCompleter = Completer<Result>();
  late final Future<Result> result;
  final List<void Function()> _guessSubscriptions = [];
  int guesses = 0;

  // private constructor
  GameController._() {
    result = _resultCompleter.future;
  }

  // Singleton instance
  static final GameController _instance = GameController._();

  /// access point to singleton instance
  factory GameController() {
    return _instance;
  }

  static Future<String> _getAnswer() async {
    Backend backend = Backend();
    return "${(await backend.songData.future)!.title} - ${(await backend.songData.future)!.artist}";
  }

  /// handles guess logic
  void guess(String guess) async {
    if (!_resultCompleter.isCompleted) {
      _guessNotify();
      if (guess == (await _answer)) {
        _resultCompleter.complete(Result.win);
        print("you won");
      } else {
        guesses++;
        if (guesses > _maxGuesses) {
          _resultCompleter.complete(Result.lose);
          print("you lost");
        }
      }
    }
  }

  /// Returns if a result has been decided
  bool isComplete() {
    return _resultCompleter.isCompleted;
  }

  /// adds a function to be run when a guess is made
  void subscribeToGuess(void Function() onGuess) {
    _guessSubscriptions.add(onGuess);
  }

  /// Runs provided subscription functions
  void _guessNotify() {
    for (void Function() function in _guessSubscriptions) {
      function();
    }
  }
}

/// Represents game results
enum Result { win, lose }
