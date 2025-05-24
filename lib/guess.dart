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

  String? _errorText;
  bool _textFieldEnabled = true;
  TextEditingController? _autocompleteController;

  @override
  void initState() {
    _disableOnResult();
    super.initState();
  }

  /// Handles text field logic for guesses
  void _submitGuess() async {
    // require controller
    if (_autocompleteController == null) {
      return;
    }
    _awaitAnswers();
    if (!GameController().isComplete()) {
      if (_autocompleteController!.text.isEmpty) {
        setState(() {
          _errorText = "Answer cannot be blank";
        });
      } else if (!(await Backend().answers.future)!
          .contains(_autocompleteController!.text)) {
        setState(() {
          _errorText = "Select an answer from the dropdown list";
        });
      } else {
        GameController().guess(_autocompleteController!.text);
        // clear guess when submitted
        _autocompleteController!.text = "";
        setState(() {
          _errorText = null;
        });
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
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) async =>
                    switch (textEditingValue.text.isEmpty) {
                  true => const Iterable.empty(),
                  false => switch (Backend().answers.isCompleted) {
                      true => (await Backend().answers.future)!.where(
                          (element) {
                            String enteredText =
                                textEditingValue.text.toLowerCase();
                            String answer = element.toLowerCase();
                            int i = 0;
                            int j = 0;
                            // check every character in entered text appears in answer
                            while ((i < enteredText.length) &&
                                (j < answer.length)) {
                              if (enteredText[i] == answer[j]) {
                                i++;
                              } else {
                                j++;
                              }
                            }
                            return (i >= enteredText.length);
                          },
                        ),
                      false => const Iterable.empty(),
                    }
                },
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  _autocompleteController = textEditingController;
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    enabled: _textFieldEnabled,
                    onSubmitted: (_) => _submitGuess(),
                    decoration: _HHTextFieldDecoration(context, _errorText),
                    style: TextStyle(
                      color: _textFieldEnabled
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.tertiary,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _errorText = null;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // submit button
          (_textFieldEnabled || GameController().isComplete())
              ? IconButton(
                  onPressed: _submitGuess,
                  icon: const Icon(Icons.check),
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
