/// Hottest Hundred Heardle
/// account.dart
///
/// The centre panel which contains the main game
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'playback.dart';

/// Panel containing main game
class HHMainPanel extends StatelessWidget {
  static const double _borderMargin = 10.0;
  static const double _borderPadding = 20.0;

  const HHMainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_borderMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_borderPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _HHGuesses()),
              _HHTrackPlayer(),
              _HHAnswerEntry(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Panel showing result of a specific guess
class _HHGuessBox extends StatelessWidget {
  static const double _guessBoxGap = 10.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: _guessBoxGap),
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
    );
  }
}

/// Answer entry section
class _HHAnswerEntry extends StatelessWidget {
  static const EdgeInsets _answerEntryPadding = EdgeInsets.all(10.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _answerEntryPadding,
      child: Row(
        children: [
          const Expanded(
            child: TextField(),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}

/// Holds the play button and information
class _HHTrackPlayer extends StatelessWidget {
  static const EdgeInsets _playerPadding = EdgeInsets.all(10.0);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      child: Padding(
        padding: _playerPadding,
        child: Row(
          children: [
            HHPlayButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _HHGuesses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HHGuessBox(),
        _HHGuessBox(),
        _HHGuessBox(),
        _HHGuessBox(),
        _HHGuessBox(),
      ],
    );
  }
}
