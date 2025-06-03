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
import "local_storage.dart";

/// Controls game logic and events
class GameController {
  static const int maxGuesses = 6;

  final Future<String> _answer = (() async {
    Backend backend = Backend();
    return "${(await backend.songData).title} - ${(await backend.songData).artist}";
  })();
  final Completer<void> _guessesLoaded = Completer<void>();
  final Completer<Result> _result = Completer<Result>();
  final GameEvent guessMade = GameEvent();
  final GameEvent duplicateGuess = GameEvent();
  final List<Completer<Guess>> _guesses = [
    for (int i = 0; i < maxGuesses; i++) Completer<Guess>(),
  ];
  late final GameEvent gameOver;

  bool userHasInteracted = false;

  Future<String> get answer =>
      Future(() async => await _result.future).then((_) => _answer);

  Future<Result> get result => _result.future;

  Future<void> get guessesLoaded => _guessesLoaded.future;

  // private constructor
  GameController._internal() {
    gameOver = GameEvent.withTrigger(_result.future);
  }

  // Singleton instance
  static final GameController _instance = GameController._internal();

  /// access point to singleton instance
  factory GameController() {
    return _instance;
  }

  /// loads guesses from local storage
  Future<void> loadGuesses() async {
    List<Guess> loadedGuesses = await LocalStorage().guesses;
    for (Guess loadedGuess in loadedGuesses) {
      if (loadedGuess.result == GuessResult.pass) {
        pass();
      } else {
        await guess(loadedGuess.guess);
      }
    }
    _guessesLoaded.complete();
  }

  /// returns the number of guesses that have been made
  int numGuesses() {
    int count = 0;
    for (Completer completer in _guesses) {
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
    return _guesses[guessNumber - 1].future;
  }

  /// handles guess logic
  Future<void> guess(String guess) async {
    if (!_result.isCompleted) {
      String answer = await _answer;
      // check for duplicate guesses
      for (Completer<Guess> completer in _guesses) {
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
        _guesses[numGuesses()].complete(Guess(guess, GuessResult.correct));
        _result.complete(Result.win);
      } else {
        _guesses[numGuesses()].complete(Guess(guess, GuessResult.incorrect));
        if (numGuesses() >= maxGuesses) {
          _result.complete(Result.lose);
        }
      }
      guessMade.trigger();
    }
  }

  /// Handles pass logic
  void pass() {
    if (!_result.isCompleted) {
      _guesses[numGuesses()].complete(Guess("Passed", GuessResult.pass));
      if (numGuesses() >= maxGuesses) {
        _result.complete(Result.lose);
      }

      guessMade.trigger();
    }
  }

  /// Retrieves a string for result sharing
  Future<String> getSharingString() async {
    String result = "";
    for (int i = 0; i < maxGuesses; i++) {
      if (_guesses[i].isCompleted) {
        result += switch ((await _guesses[i].future).result) {
          GuessResult.correct => "🟩",
          GuessResult.pass => "⬜️",
          GuessResult.incorrect => "🟥",
        };
      } else {
        result += "⬛️";
      }
    }
    return result;
  }

  /// Returns if a result has been decided
  bool isComplete() {
    return _result.isCompleted;
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
  static const String _delimiter = "|";

  final String guess;
  final GuessResult result;
  Guess(this.guess, this.result);

  /// creates a guess from an encoded string
  factory Guess.fromString(String guessString) {
    List<String> tokens = guessString.split(_delimiter);
    String guess = tokens[0];
    GuessResult result = switch (tokens[1]) {
      "correct" => GuessResult.correct,
      "incorrect" => GuessResult.incorrect,
      "pass" => GuessResult.pass,
      String() => throw UnsupportedError("result ${tokens[1]} not supported"),
    };
    return Guess(guess, result);
  }

  @override
  String toString() {
    return "$guess$_delimiter${result.name}";
  }
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
  pass(icon: GuessResultIcon(Icons.check_box_outline_blank, Colors.grey)),
  incorrect(icon: GuessResultIcon(Icons.close, Colors.red));

  const GuessResult({required this.icon});

  final GuessResultIcon icon;
}
