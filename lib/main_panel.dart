/// Hottest Hundred Heardle
/// main_panel.dart
///
/// The centre panel which contains the main game
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'playback.dart';
import "guess.dart";

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
        child: const Padding(
          padding: EdgeInsets.all(_borderPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: HHGuesses(),
              ),
              HHTrackPlayer(),
              HHAnswerEntry(),
            ],
          ),
        ),
      ),
    );
  }
}
