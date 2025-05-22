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

  final Future<String> _answer = (() async {
    Backend backend = Backend();
    return "${(await backend.songData.future)!.title} - ${(await backend.songData.future)!.artist}";
  })();
  final Completer<Result> _resultCompleter = Completer<Result>();
  final GameEvent guessMade = GameEvent();
  late final GameEvent gameOver;
  late final Future<Result> result;
  int guesses = 0;

  // private constructor
  GameController._() {
    result = _resultCompleter.future;
    guessMade.subscribe(() {
      guesses++;
    });
    gameOver = GameEvent.withTrigger(result);
  }

  // Singleton instance
  static final GameController _instance = GameController._();

  /// access point to singleton instance
  factory GameController() {
    return _instance;
  }

  /// handles guess logic
  void guess(String guess) async {
    if (!_resultCompleter.isCompleted) {
      guessMade.trigger();
      if (guess == (await _answer)) {
        _resultCompleter.complete(Result.win);
      } else {
        if (guesses > _maxGuesses) {
          _resultCompleter.complete(Result.lose);
        }
      }
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

/// Represents game results
enum Result { win, lose }
