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
import 'result.dart';

/// Panel containing main game
class HHMainPanel extends StatelessWidget {
  static const double _borderMargin = 10.0;
  static const double _borderPadding = 20.0;
  static const double _maxWidth = 560.0;

  const HHMainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _maxWidth,
      ),
      child: Padding(
        padding: const EdgeInsets.all(_borderMargin),
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(
                    _borderPadding,
                    _borderPadding,
                    _borderPadding,
                    0.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: HHGuesses()),
                      HHTrackPlayer(),
                      HHAnswerEntry(),
                    ],
                  ),
                ),
              ),
            ),
            HHResults(),
          ],
        ),
      ),
    );
  }
}
