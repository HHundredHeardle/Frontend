/// Hottest Hundred Heardle
/// account.dart
///
/// The centre panel which contains the main game
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

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
              _HHGuessBox(),
              _HHGuessBox(),
              _HHGuessBox(),
              _HHGuessBox(),
              _HHGuessBox(),
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
  static const double _guessBoxHeight = 75.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _guessBoxHeight,
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
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
            _HHPlayButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

/// Button to play track
class _HHPlayButton extends StatelessWidget {
  static const double _iconRadius = 24.0;

  final void Function() onPressed;

  const _HHPlayButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        borderRadius: BorderRadius.circular(_iconRadius),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
