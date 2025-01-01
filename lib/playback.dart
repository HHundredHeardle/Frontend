/// Hottest Hundred Heardle
/// playback.dart
///
/// The play button and audio playback handling
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

/// Button to play track
class HHPlayButton extends StatefulWidget {
  final void Function() onPressed;

  const HHPlayButton({required this.onPressed});

  @override
  State<HHPlayButton> createState() => _HHPlayButtonState();
}

class _HHPlayButtonState extends State<HHPlayButton> {
  static const double _iconRadius = 24.0;

  bool _playing = false;

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
        onPressed: () {
          setState(() {
            _playing = !_playing;
          });
          widget.onPressed;
        },
        icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
