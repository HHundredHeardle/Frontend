/// Hottest Hundred Heardle
/// playback.dart
///
/// The play button and audio playback handling
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

import '../utils/backend.dart';
import '../utils/game_controller.dart';

/// Holds the play button and information
class HHTrackPlayer extends StatelessWidget {
  static const double _paddingSize = 10.0;
  static const EdgeInsets _playerPadding = EdgeInsets.all(_paddingSize);
  static const double _height = 40.0;

  const HHTrackPlayer({super.key});

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
        child: SizedBox(
          height: _height,
          child: Row(
            children: [
              SizedBox.square(
                dimension: _height,
                child: const _HHAudioController(),
              ),
              const SizedBox(
                width: _paddingSize,
              ),
              Expanded(
                child: _HHPlayerBar(),
              ),
            ],
          ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        borderRadius: BorderRadius.circular(_iconRadius),
      ),
      child: FutureBuilder(
        future: (GameController().isComplete()
                ? Backend().getClip(6)
                : Backend().getClip(GameController().numGuesses() + 1))
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
      await setAudioSource((await Backend().getClip(6)));
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

class _HHPlayerBar extends StatefulWidget {
  @override
  State<_HHPlayerBar> createState() => _HHPlayerBarState();
}

class _HHPlayerBarState extends State<_HHPlayerBar> {
  static const int _totalSeconds = 30;
  static const double _fullHeight = 1.0;
  static const double _playerHeightFactor = 0.2;
  static const List<int> _clipFlexes = [7, 6, 22, 38, 38, 119];
  static const int _dividerFlex = 2;

  final Stream<Duration> _stream = _HHAudioPlayer().positionStream;

  static Color _playedColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color _unplayedColor(BuildContext context) =>
      Theme.of(context).disabledColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      heightFactor: _playerHeightFactor,
      child: Stack(
        children: [
          StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              double progress =
                  ((snapshot.data ?? Duration.zero).inMilliseconds /
                          Duration(seconds: _totalSeconds).inMilliseconds)
                      .clamp(0.0, 1.0);
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _unplayedColor(context),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  heightFactor: _fullHeight,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _playedColor(context),
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              for (int i = 0; i < (_clipFlexes.length * 2) - 1; i++)
                if (i % 2 == 0)
                  Expanded(
                    flex: _clipFlexes[i ~/ 2],
                    child: Container(),
                  )
                else
                  Expanded(
                    flex: _dividerFlex,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
