/// Hottest Hundred Heardle
/// guess.dart
///
/// Widgets for handling guess logic and feedback
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'backend.dart';
import 'game_controller.dart';

/// Widget group containing guess boxes
class HHGuesses extends StatelessWidget {
  const HHGuesses({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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

/// Answer entry section
class HHAnswerEntry extends StatefulWidget {
  const HHAnswerEntry({super.key});

  @override
  State<HHAnswerEntry> createState() => _HHAnswerEntryState();
}

class _HHAnswerEntryState extends State<HHAnswerEntry> {
  static const double _textBoxHeight = 68.0;
  static const EdgeInsets _answerEntryPadding = EdgeInsets.all(10.0);
  static const double _loadingIndicatorStrokeWidth = 1.0;

  final TextEditingController _textController = TextEditingController();
  String? _errorText;
  bool _textFieldEnabled = true;

  @override
  void initState() {
    _disableOnResult();
    super.initState();
  }

  /// Handles text field logic for guesses
  void _submitGuess() async {
    _awaitAnswers();
    if (!GameController().isComplete()) {
      if (_textController.text.isEmpty) {
        setState(() {
          _errorText = "Answer cannot be blank";
        });
      } else if (!(await Backend().answers.future)!
          .contains(_textController.text)) {
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

  /// Disables text field while answers are loading
  void _awaitAnswers() async {
    if (!Backend().answers.isCompleted) {
      setState(() {
        _textFieldEnabled = false;
      });
      await Backend().answers.future;
      setState(() {
        _textFieldEnabled = true;
      });
    }
  }

  /// Disables textfield on game win
  void _disableOnResult() async {
    await GameController().result;
    setState(() {
      _textFieldEnabled = false;
    });
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

              // text field
              child: TextField(
                enabled: _textFieldEnabled,
                decoration: _HHTextFieldDecoration(context, _errorText),
                controller: _textController,
                style: TextStyle(
                  color: _textFieldEnabled
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.tertiary,
                ),
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

          // submit button
          (_textFieldEnabled || GameController().isComplete())
              ? IconButton(
                  onPressed: _submitGuess,
                  icon: const Icon(Icons.check),
                  tooltip: _textController.text,
                )
              : const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: _loadingIndicatorStrokeWidth,
                ),
        ],
      ),
    );
  }
}

/// Panel showing result of a specific guess
class _HHGuessBox extends StatelessWidget {
  static const double _guessBoxGap = 10.0;

  const _HHGuessBox();

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
