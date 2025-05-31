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
import 'game_controller.dart';

/// Holds the play button and information
class HHTrackPlayer extends StatelessWidget {
  static const EdgeInsets _playerPadding = EdgeInsets.all(10.0);

  const HHTrackPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      child: const Padding(
        padding: _playerPadding,
        child: Row(
          children: [
            _HHAudioController(),
            // playback bar
          ],
        ),
      ),
    );
  }
}

/// Button to play track
class _HHAudioController extends StatefulWidget {
  const _HHAudioController();

  @override
  State<_HHAudioController> createState() => _HHAudioControllerState();
}

class _HHAudioControllerState extends State<_HHAudioController> {
  static const double _iconRadius = 24.0;
  static const double _size = 40.0;

  @override
  void initState() {
    // rebuild widget when a guess is made
    GameController().guessMade.subscribe(() {
      setState(() {});
    });
    super.initState();
  }

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
          future: (GameController().isComplete()
                  ? Backend().clip6.future
                  : switch (GameController().numGuesses()) {
                      0 => Backend().clip1.future,
                      1 => Backend().clip2.future,
                      2 => Backend().clip3.future,
                      3 => Backend().clip4.future,
                      4 => Backend().clip5.future,
                      >= 5 => Backend().clip6.future,
                      int() =>
                        throw UnsupportedError("Invalid number of guesses"),
                    })
              .then((audioSource) async {
            await _HHAudioPlayer().setAudioSource(audioSource);
            return audioSource;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return const _HHPlayButton();
              } else {
                debugPrint(
                  "${(_HHAudioControllerState).toString()}.build: snapshot.toString(): ${snapshot.toString()}",
                );
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

/// audio player
class _HHAudioPlayer extends AudioPlayer {
  final GameEvent pauseEvent = GameEvent();

  // private constructor
  _HHAudioPlayer._() {
    // pause and reset player once track finishes
    processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        pause();
        pauseEvent.trigger();
        seek(Duration.zero);
      }
    });
    // pause player when a guess is made
    GameController().guessMade.subscribe(
      () {
        pause();
        pauseEvent.trigger();
        seek(Duration.zero);
      },
    );
    // play full track on game over
    GameController().gameOver.subscribe(() async {
      pause();
      await setAudioSource((await Backend().clip6.future));
      pauseEvent.trigger();
      seek(Duration.zero);
      play();
    });
  }

  // Singleton instance
  static final _HHAudioPlayer _instance = _HHAudioPlayer._();

  /// access point to singleton instance
  factory _HHAudioPlayer() {
    return _instance;
  }
}

/// The play/pause button that responds to audio state
class _HHPlayButton extends StatefulWidget {
  const _HHPlayButton();

  @override
  State<_HHPlayButton> createState() => _HHPlayButtonState();
}

class _HHPlayButtonState extends State<_HHPlayButton> {
  @override
  void initState() {
    // update on pause/play
    _HHAudioPlayer().pauseEvent.subscribe(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // play/pause player
        setState(() {
          if (_HHAudioPlayer().playerState.playing) {
            _HHAudioPlayer().pause();
          } else {
            _HHAudioPlayer().play();
          }
        });
      },
      // toggle icon based on player state
      icon: Icon(
        _HHAudioPlayer().playerState.playing ? Icons.pause : Icons.play_arrow,
      ),
    );
  }
}
