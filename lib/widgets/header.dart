/// Hottest Hundred Heardle
/// header.dart
///
/// The header widget
///
/// Authors: Joshua Linehan
library;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../utils/date.dart';
import '../utils/game_controller.dart';

import 'dart:async';

/// Widget for the header of the app. Contains title, drawer, and account icon
class HHHeader extends StatelessWidget {
  static const double _headerHeight = 50.0;

  const HHHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _headerHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        child: Stack(
          children: [
            _HHTitle(),
            _HHCountdown(),
          ],
        ),
      ),
    );
  }
}

/// The title displayed in the header
class _HHTitle extends StatelessWidget {
  static const String _title = "Hottest Hundred Heardle";

  const _HHTitle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

/// Countdown to next heardle
class _HHCountdown extends StatefulWidget {
  @override
  State<_HHCountdown> createState() => _HHCountdownState();
}

class _HHCountdownState extends State<_HHCountdown> {
  static const double _hiddenOpacity = 0.0;
  static const double _showOpacity = 1.0;
  static const Duration _opacityDuration = Duration.zero;
  static const double _hiddenDy = -1.0;
  static const double _showDy = 0.0;
  static const Duration _dyDuration = Duration(milliseconds: 1500);
  static const double _countdownLetterSpacing = 3.0;
  static const double _countdownTopPadding = 5.0;

  double _opacity = _hiddenOpacity;
  double _dy = _hiddenDy;

  /// Triggers animation to show the countdown
  void show() {
    setState(() {
      _opacity = _showOpacity;
      _dy = _showDy;
    });
  }

  @override
  void initState() {
    // register snackbar to appear at game end
    GameController().gameOver.subscribe(show);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: _opacityDuration,
      child: AnimatedSlide(
        curve: Curves.ease,
        duration: _dyDuration,
        offset: Offset(0.0, _dy),
        child: Container(
          decoration: BoxDecoration(
            color: ColorScheme.of(context).primary,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: _countdownTopPadding),
              child: Column(
                children: [
                  Text(
                    "Next Heardle in",
                    style: TextTheme.of(context).bodySmall,
                  ),
                  _HHCountdownText(
                    style: TextTheme.of(context).titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: _countdownLetterSpacing,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The text for the countdown
class _HHCountdownText extends StatefulWidget {
  final TextStyle? style;

  const _HHCountdownText({this.style});

  @override
  State<_HHCountdownText> createState() => _HHCountdownTextState();
}

class _HHCountdownTextState extends State<_HHCountdownText> {
  static const Duration _oneSecond = Duration(seconds: 1);

  final Future<Duration> _timeToNext = (() async {
    DateTime now = await HHDate().date;
    DateTime next = now.add(Duration(days: 1)).copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
    return next.difference(now);
  })();
  Duration? _countdownTime;
  Timer? _timer;
  bool _timerStarted = false;

  /// starts a timer for the remaining time to next heardle, updates every
  /// second
  void _startTimer() {
    _timeToNext.then((value) => setState(() => _countdownTime = value));
    Timer.periodic(_oneSecond, (Timer timer) {
      if (_countdownTime! == Duration.zero) {
        timer.cancel();
      } else {
        setState(() => _countdownTime = _countdownTime! - _oneSecond);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _timeToNext,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (!snapshot.hasError) {
              // start timer
              if (!_timerStarted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _startTimer();
                  setState(() => _timerStarted = true);
                });
              }
              // return text
              return AutoSizeText(
                _countdownTime
                    .toString()
                    // trim milliseconds off time string
                    .replaceFirst(RegExp(r"\.\d{6}$"), ""),
                style: widget.style,
                maxLines: 1,
              );
            }
          }
        }
        return Container();
      },
    );
  }
}
