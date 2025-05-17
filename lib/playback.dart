/// Hottest Hundred Heardle
/// playback.dart
///
/// The play button and audio playback handling
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'backend.dart';

/// Button to play track
class HHPlayButton extends StatefulWidget {
  const HHPlayButton({super.key});

  @override
  State<HHPlayButton> createState() => _HHPlayButtonState();
}

class _HHPlayButtonState extends State<HHPlayButton> {
  static const double _iconRadius = 24.0;
  static const double _size = 40.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(_iconRadius),
        ),
        child: FutureBuilder(
          future: Backend().clip1.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return _HHAudioPlayer(snapshot.data!);
              } else {
                debugPrint(
                    "_HHPlayButtonState.build: snapshot.toString(): ${snapshot.toString()}");
                return const Tooltip(
                  message: "Error loading audio",
                  child: Icon(Icons.error),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

/// Handles audio play and pausing
class _HHAudioPlayer extends StatefulWidget {
  final StreamAudioSource audio;

  const _HHAudioPlayer(this.audio);
  @override
  State<_HHAudioPlayer> createState() => _HHAudioPlayerState();
}

class _HHAudioPlayerState extends State<_HHAudioPlayer> {
  late final AudioPlayer _player;

  @override
  void initState() {
    _player = AudioPlayer();
    _player.setAudioSource(widget.audio);
    // pause and reset player once track finishes
    _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        setState(() {
          _player.pause();
          _player.seek(Duration.zero);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // play/pause player
        setState(() {
          if (_player.playerState.playing) {
            _player.pause();
          } else {
            _player.play();
          }
        });
      },
      // toggle icon based on player state
      icon: Icon(
        _player.playerState.playing ? Icons.pause : Icons.play_arrow,
      ),
    );
  }
}
