/// Hottest Hundred Heardle
/// result.dart
///
/// Widgets that display game result
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'game_controller.dart';

/// Displays the result of the game
class HHResults extends StatelessWidget {
  const HHResults({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_HHResult(), const _HHAnswer(), const _HHStreak()],
    );
  }
}

/// Displays number of guesses or failure message
class _HHResult extends StatelessWidget {
  final Future<Result> _result = GameController().result;

  _HHResult();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _result,
      builder: (context, snapshot) {
        int guesses = GameController().numGuesses();
        return (snapshot.connectionState == ConnectionState.done)
            ? Text(
                switch (snapshot.data!) {
                  Result.win =>
                    "You got today's answer in $guesses guess${(guesses != 1) ? "es" : ""}",
                  Result.lose => "You didn't get today's answer",
                },
              )
            : Container();
      },
    );
  }
}

/// Displays the song information
class _HHAnswer extends StatelessWidget {
  const _HHAnswer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

/// Displays streak information
class _HHStreak extends StatelessWidget {
  const _HHStreak();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
