/// Hottest Hundred Heardle
/// guess.dart
///
/// Widgets for handling guess logic and feedback
///
/// Authors: Joshua Linehan
// ignore_for_file: require_trailing_commas

library;

import 'dart:async';

import 'package:flutter/material.dart';
import "package:flutter/scheduler.dart";

import '../utils/backend.dart';
import '../utils/game_controller.dart';

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
          _HHGuessBox(GameController().getGuess(i + 1)),
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
  static const double _textHighlightAlpha = 102.0;
  static const double _optionsMaxWidth = 500.0;
  static const double _optionsMaxHeight = 690.0;
  static const int _hoverColorBlendAlpha = 22;
  static const EdgeInsets _optionPadding = EdgeInsets.all(16.0);
  static const double _optionElevation = 4.0;

  String? _errorText;
  bool _textFieldEnabled = true;
  TextEditingController? _autocompleteController;
  FocusNode? _focusNode;

  @override
  void initState() {
    GameController().duplicateGuess.subscribe(
      () {
        setState(() {
          _errorText = "Answer has already been entered";
        });
      },
    );
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
      } else if (!(await Backend().answers)
          .contains(_autocompleteController!.text)) {
        setState(() {
          _errorText = "Select an answer from the list";
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
    if (!Backend().answersComplete) {
      setState(() {
        _textFieldEnabled = false;
      });
      await Backend().answers;
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
    await Backend().answers;
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
          // pass button
          TextButton(
            onPressed: _textFieldEnabled ? () => GameController().pass() : null,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "PASS",
              style: TextStyle(
                color: _textFieldEnabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context)
                        .iconButtonTheme
                        .style
                        ?.iconColor
                        ?.resolve({WidgetState.disabled}),
              ),
            ),
          ),

          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _textFieldEnabled
                ? () => FocusScope.of(context).requestFocus(_focusNode)
                : null,
          ),

          Expanded(
            child: SizedBox(
              height: _textBoxHeight,
              // text field
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) async =>
                    switch (textEditingValue.text.isEmpty) {
                  true => const Iterable.empty(),
                  false => switch (Backend().answersComplete) {
                      false => const ["Loading..."],
                      true => (await Backend().answers).where(
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
                  _focusNode = focusNode;
                  return TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      selectionColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: _textHighlightAlpha),
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
                            return Backend().answersComplete
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
                  onPressed: _textFieldEnabled ? _submitGuess : null,
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
  static const EdgeInsets _guessBoxPadding =
      EdgeInsets.symmetric(horizontal: 16.0);

  final Future<Guess> guess;

  const _HHGuessBox(this.guess);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: guess,
        builder: (context, snapshot) => Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: Center(
            child: Padding(
              padding: _guessBoxPadding,
              child: (snapshot.connectionState == ConnectionState.done)
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            snapshot.data!.guess,
                            style: TextStyle(
                              color: (snapshot.data!.result == GuessResult.pass)
                                  ? Theme.of(context).disabledColor
                                  : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        snapshot.data!.result.icon
                      ],
                    )
                  : null,
            ),
          ),
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
