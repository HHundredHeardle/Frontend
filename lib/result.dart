/// Hottest Hundred Heardle
/// result.dart
///
/// Widgets that display game result
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

/// Displays the result of the game
class HHResults extends StatelessWidget {
  const HHResults({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [_HHResult(), _HHAnswer(), _HHStreak()],
    );
  }
}

/// Displays number of guesses or failure message
class _HHResult extends StatelessWidget {
  const _HHResult();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
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
