/// Hottest Hundred Heardle
/// guess.dart
///
/// Widgets for handling guess logic and feedback
///
/// Authors: Joshua Linehan
// ignore_for_file: require_trailing_commas

library;

import 'package:flutter/material.dart';
import "package:flutter/scheduler.dart";

import 'backend.dart';
import 'game_controller.dart';

/// Widget group containing guess boxes
class HHGuesses extends StatelessWidget {
  static const Widget _separator = SizedBox(
    height: 10.0,
  );

  const HHGuesses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < GameController.maxGuesses; i++) ...[
          const _HHGuessBox(),
          _separator,
        ]
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
  static const double _textHighlightOpacity = 0.4;
  static const double _optionsMaxWidth = 500.0;
  static const double _optionsMaxHeight = 690.0;
  static const int _hoverColorBlendAlpha = 22;
  static const EdgeInsets _optionPadding = EdgeInsets.all(16.0);
  static const double _optionElevation = 4.0;

  String? _errorText;
  bool _textFieldEnabled = true;
  TextEditingController? _autocompleteController;

  @override
  void initState() {
    _disableOnResult();
    _reloadOnAnswerLoad();
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

  /// reloads widget when answers load
  void _reloadOnAnswerLoad() async {
    await Backend().answers.future;
    setState(() {});
    // trigger a rebuild of options
    _autocompleteController!.text = _autocompleteController!.text;
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
                      false => const ["Loading..."],
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
                              }
                              j++;
                            }
                            return (i >= enteredText.length);
                          },
                        )
                    }
                },
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  _autocompleteController = textEditingController;
                  return TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      selectionColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(_textHighlightOpacity),
                    ),
                    child: TextField(
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
                    ),
                  );
                },
                optionsViewOpenDirection: OptionsViewOpenDirection.up,
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Material(
                      elevation: _optionElevation,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _optionsMaxWidth,
                          maxHeight: _optionsMaxHeight,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return Backend().answers.isCompleted
                                ? InkWell(
                                    hoverColor: Color.alphaBlend(
                                      Colors.white
                                          .withAlpha(_hoverColorBlendAlpha),
                                      Theme.of(context).hoverColor,
                                    ),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: Builder(
                                        builder: (BuildContext context) {
                                      final bool highlight =
                                          AutocompleteHighlightedOption.of(
                                                  context) ==
                                              index;
                                      if (highlight) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback(
                                          (Duration timeStamp) {
                                            Scrollable.ensureVisible(context);
                                          },
                                        );
                                      }
                                      return Container(
                                        color: highlight
                                            ? Theme.of(context).focusColor
                                            : null,
                                        padding: _optionPadding,
                                        child: Text(
                                          option,
                                        ),
                                      );
                                    }),
                                  )
                                : Container(
                                    padding: _optionPadding,
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
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
  const _HHGuessBox();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
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
