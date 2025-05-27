/// Hottest Hundred Heardle
/// result.dart
///
/// Widgets that display game result
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'backend.dart';
import 'game_controller.dart';
import 'song_data.dart';

/// Displays the result of the game
class HHResults extends StatelessWidget {
  const HHResults({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HHResult(),
        _HHResultsDivider(),
        _HHAnswer(),
        _HHResultsDivider(),
        _HHStreak(),
      ],
    );
  }
}

/// Displays number of guesses or failure message
class _HHResult extends StatelessWidget {
  final Future<Result> _result = GameController().result;

  _HHResult();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
        future: _result,
        builder: (context, snapshot) {
          int guesses = GameController().numGuesses();
          return (snapshot.connectionState == ConnectionState.done)
              ? Text(
                  switch (snapshot.data!) {
                    Result.win =>
                      "You got today's answer in $guesses guess${(guesses != 1) ? "es" : ""}",
                    Result.lose => "You didn't get today's answer",
                  },
                )
              : Container();
        },
      ),
    );
  }
}

/// Displays the song information
class _HHAnswer extends StatelessWidget {
  final Future<String> _answer = GameController().answer;
  final Future<SongData?> _songData = Backend().songData.future;

  _HHAnswer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
        future: _answer,
        builder: (context, snapshot) =>
            (snapshot.connectionState == ConnectionState.done)
                ?
                // Answer widget
                Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: _songData,
                        builder: (context, snapshot) =>
                            (snapshot.connectionState == ConnectionState.done)
                                ?
                                // Year and place
                                _HHCountdownData(snapshot.data!)
                                : const CircularProgressIndicator(),
                      ),
                    ],
                  )
                : Container(),
      ),
    );
  }
}

/// Displays information about the countdown a song is from
class _HHCountdownData extends StatelessWidget {
  static const double _opaque = 1.0;
  static const Map<int, _CountdownColour> _colours = {
    1993:
        _CountdownColour(Color.fromRGBO(131, 168, 125, _opaque), Colors.black),
    1994:
        _CountdownColour(Color.fromRGBO(224, 135, 124, _opaque), Colors.black),
    1995: _CountdownColour(Color.fromRGBO(92, 73, 72, _opaque), Colors.white),
    1996:
        _CountdownColour(Color.fromRGBO(136, 181, 159, _opaque), Colors.black),
    1997: _CountdownColour(Color.fromRGBO(94, 134, 150, _opaque), Colors.black),
    1998: _CountdownColour(Color.fromRGBO(227, 209, 83, _opaque), Colors.black),
    1999: _CountdownColour(Color.fromRGBO(150, 196, 65, _opaque), Colors.black),
    2000: _CountdownColour(Color.fromRGBO(183, 98, 94, _opaque), Colors.black),
    2001:
        _CountdownColour(Color.fromRGBO(234, 137, 103, _opaque), Colors.black),
    2002: _CountdownColour(Color.fromRGBO(120, 91, 80, _opaque), Colors.white),
    2003:
        _CountdownColour(Color.fromRGBO(204, 196, 163, _opaque), Colors.black),
    2004:
        _CountdownColour(Color.fromRGBO(219, 175, 199, _opaque), Colors.black),
    2005:
        _CountdownColour(Color.fromRGBO(174, 184, 152, _opaque), Colors.black),
    2006: _CountdownColour(Color.fromRGBO(96, 95, 132, _opaque), Colors.white),
    2007:
        _CountdownColour(Color.fromRGBO(236, 187, 114, _opaque), Colors.black),
    2008:
        _CountdownColour(Color.fromRGBO(159, 218, 232, _opaque), Colors.black),
    2009:
        _CountdownColour(Color.fromRGBO(114, 165, 165, _opaque), Colors.black),
    2010:
        _CountdownColour(Color.fromRGBO(221, 132, 180, _opaque), Colors.black),
    2011: _CountdownColour(Color.fromRGBO(82, 157, 163, _opaque), Colors.black),
    2012: _CountdownColour(Color.fromRGBO(250, 163, 27, _opaque), Colors.black),
    2013: _CountdownColour(Color.fromRGBO(69, 47, 146, _opaque), Colors.white),
    2014: _CountdownColour(Color.fromRGBO(238, 61, 89, _opaque), Colors.black),
    2015: _CountdownColour(Color.fromRGBO(16, 157, 187, _opaque), Colors.black),
    2016: _CountdownColour(Color.fromRGBO(231, 14, 68, _opaque), Colors.white),
    2017:
        _CountdownColour(Color.fromRGBO(254, 149, 173, _opaque), Colors.black),
    2018: _CountdownColour(Color.fromRGBO(181, 204, 62, _opaque), Colors.black),
    2019: _CountdownColour(Color.fromRGBO(244, 171, 68, _opaque), Colors.black),
    2020: _CountdownColour(Color.fromRGBO(239, 43, 204, _opaque), Colors.black),
    2021: _CountdownColour(Color.fromRGBO(0, 135, 0, _opaque), Colors.white),
    2022:
        _CountdownColour(Color.fromRGBO(248, 215, 189, _opaque), Colors.black),
    2023: _CountdownColour(Color.fromRGBO(221, 121, 62, _opaque), Colors.black),
    2024: _CountdownColour(Color.fromRGBO(119, 38, 127, _opaque), Colors.white),
  };
  static const _padding = EdgeInsets.symmetric(horizontal: 5.0);
  final SongData _songData;

  const _HHCountdownData(this._songData);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _colours[_songData.year]!.background,
      ),
      child: Row(
        children: [
          Padding(
            padding: _padding,
            child: Text(
              "#${_songData.place}",
              style: TextStyle(
                color: _colours[_songData.year]!.text,
              ),
            ),
          ),
          Padding(
            padding: _padding,
            child: Text(
              _songData.year.toString(),
              style: TextStyle(
                color: _colours[_songData.year]!.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays streak information
class _HHStreak extends StatelessWidget {
  final int _currentStreak = 0; //TODO: get streak
  final int _maxStreak = 0; //TODO: get streak
  final Future<Result> _result = GameController().result;

  _HHStreak();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
        future: _result,
        builder: (context, snapshot) =>
            (snapshot.connectionState == ConnectionState.done)
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Current streak: $_currentStreak",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Longest streak: $_maxStreak",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Container(),
      ),
    );
  }
}

/// Colour data for a countdown year
class _CountdownColour {
  final Color background;
  final Color text;
  const _CountdownColour(this.background, this.text);
}

/// Divider for results widget
class _HHResultsDivider extends StatefulWidget {
  @override
  State<_HHResultsDivider> createState() => _HHResultsDividerState();
}

class _HHResultsDividerState extends State<_HHResultsDivider> {
  static const Color _activeColor = Colors.white;
  static const Color _inactiveColor = Color.fromARGB(0, 0, 0, 0);

  Color _color = _inactiveColor;

  @override
  void initState() {
    GameController().result.whenComplete(() {
      setState(() {
        _color = _activeColor;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: _color,
    );
  }
}
