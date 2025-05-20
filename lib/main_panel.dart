/// Hottest Hundred Heardle
/// account.dart
///
/// The centre panel which contains the main game
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'playback.dart';
import 'game_controller.dart';
import 'backend.dart';

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
class _HHAnswerEntry extends StatefulWidget {
  @override
  State<_HHAnswerEntry> createState() => _HHAnswerEntryState();
}

class _HHAnswerEntryState extends State<_HHAnswerEntry> {
  static const double _textBoxHeight = 68.0;
  static const EdgeInsets _answerEntryPadding = EdgeInsets.all(10.0);

  final TextEditingController _textController = TextEditingController();
  String? _errorText;

  void _submitGuess() async {
    if (!GameController().isComplete()) {
      if (_textController.text.isEmpty) {
        setState(() {
          _errorText = "Answer cannot be blank";
        });
      } else if (!(await Backend().answers)!.contains(_textController.text)) {
        setState(() {
          _errorText = "Select an answer from the dropdown list";
        });
      } else {
        GameController().guess(_textController.text);
        // clear text after guess
        _textController.text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _answerEntryPadding,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: _textBoxHeight,
              child: TextField(
                decoration: _HHTextFieldDecoration(context, _errorText),
                controller: _textController,
                onSubmitted: (_) {
                  _submitGuess();
                },
                onChanged: (_) {
                  setState(() {
                    _errorText = null;
                  });
                },
              ),
            ),
          ),
          IconButton(
            onPressed: _submitGuess,
            icon: const Icon(Icons.check),
            tooltip: _textController.text,
          ),
        ],
      ),
    );
  }
}

/// Decoration for text field
class _HHTextFieldDecoration extends InputDecoration {
  _HHTextFieldDecoration(BuildContext context, String? errorText)
      : super(
          errorText: errorText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        );
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
      child: const Padding(
        padding: _playerPadding,
        child: Row(
          children: [
            HHPlayButton(),
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
