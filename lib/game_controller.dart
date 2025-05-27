/// Hottest Hundred Heardle
/// game_controller.dart
///
/// Handles game logic and events
///
/// Authors: Joshua Linehan
library;

import "dart:async";

import "package:flutter/material.dart";

import 'backend.dart';

/// Controls game logic and events
class GameController {
  static const int maxGuesses = 6;

  final Future<String> _answer = (() async {
    Backend backend = Backend();
    return "${(await backend.songData.future)!.title} - ${(await backend.songData.future)!.artist}";
  })();
  final Completer<Result> _resultCompleter = Completer<Result>();
  final GameEvent guessMade = GameEvent();
  final GameEvent duplicateGuess = GameEvent();
  final List<Completer<Guess>> _guessCompleters = [
    for (int i = 0; i < maxGuesses; i++) Completer<Guess>(),
  ];
  late final List<Future<Guess>> _guesses;
  late final GameEvent gameOver;
  late final Future<Result> result;

  Future<String> get answer =>
      Future(() async => await result).then((_) => _answer);

  // private constructor
  GameController._() {
    result = _resultCompleter.future;
    _guesses = [
      for (Completer<Guess> completer in _guessCompleters) completer.future,
    ];
    gameOver = GameEvent.withTrigger(result);
  }

  // Singleton instance
  static final GameController _instance = GameController._();

  /// access point to singleton instance
  factory GameController() {
    return _instance;
  }

  /// returns the number of guesses that have been made
  int numGuesses() {
    int count = 0;
    for (Completer completer in _guessCompleters) {
      if (completer.isCompleted) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// returns the nth guess (starting from 1)
  Future<Guess> getGuess(int guessNumber) {
    return _guesses[guessNumber - 1];
  }

  /// handles guess logic
  void guess(String guess) async {
    if (!_resultCompleter.isCompleted) {
      String answer = await _answer;
      // check for duplicate guesses
      for (Completer<Guess> completer in _guessCompleters) {
        if (completer.isCompleted) {
          if ((await completer.future).guess == guess) {
            duplicateGuess.trigger();
            return;
          }
        } else {
          break;
        }
      }
      if (guess == answer) {
        _guessCompleters[numGuesses()]
            .complete(Guess(guess, GuessResult.correct));
        _resultCompleter.complete(Result.win);
      } else {
        _guessCompleters[numGuesses()]
            .complete(Guess(guess, GuessResult.incorrect));
        if (numGuesses() >= maxGuesses) {
          _resultCompleter.complete(Result.lose);
        }
      }
      guessMade.trigger();
    }
  }

  /// Returns if a result has been decided
  bool isComplete() {
    return _resultCompleter.isCompleted;
  }
}

/// Handles game events
class GameEvent {
  final List<void Function()> _subscriptions = [];

  GameEvent();

  /// Registers future which triggers event
  GameEvent.withTrigger(Future event) {
    _setTrigger(event);
  }

  /// triggers event when future completes
  void _setTrigger(Future event) async {
    await event;
    trigger();
  }

  /// calls all subscribed functions
  void trigger() {
    for (void Function() function in _subscriptions) {
      function();
    }
  }

  /// registers a function to be called when this event is triggered
  void subscribe(void Function() function) {
    _subscriptions.add(function);
  }
}

/// represents a guess
class Guess {
  final String guess;
  final GuessResult result;
  Guess(this.guess, this.result);
}

/// Icon displayed in guess result
class GuessResultIcon extends Icon {
  const GuessResultIcon(IconData super.icon, Color color, {super.key})
      : super(color: color);
}

/// Represents game results
enum Result { win, lose }

/// Represents guess results
enum GuessResult {
  correct(icon: GuessResultIcon(Icons.check, Colors.green)),
  incorrect(icon: GuessResultIcon(Icons.close, Colors.red));

  const GuessResult({required this.icon});

  final GuessResultIcon icon;
}
