/// Hottest Hundred Heardle
/// error.dart
///
/// Handles displaying error messages
///
/// Authors: Joshua Linehan
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/backend.dart';

/// Handles error messages
class Error {
  /// Checks for backend spindown
  static void spindown(BuildContext context) {
    const Duration waitTime = Duration(seconds: 3);
    Timer(waitTime, () {
      if (!Backend().answersComplete) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            const double width = 400;
            const double height = 200.0;
            const double padding = 16.0;
            const double buttonPadding = 12.0;
            const double spacer = 25.0;
            const double buttonTextSize = 15.0;
            Backend().answers.whenComplete(
              () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
            return Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width, maxHeight: height),
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Due to the restrictions of our web service, initial data can take over two minutes to load.",
                        style: TextTheme.of(context).titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: spacer,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ColorScheme.of(context).onPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(buttonPadding),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontSize: buttonTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }
}
