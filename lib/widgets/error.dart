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
  static BuildContext? _context;

  static set context(BuildContext context) => _context = context;

  /// Checks for backend spindown
  static void spindown() {
    if (_context == null) {
      return;
    }
    const Duration waitTime = Duration(seconds: 3);
    Timer(waitTime, () {
      if (!Backend().answersComplete) {
        showDialog(
          context: _context!,
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
                        "Backend services are spinning up. This takes around 2 minutes from first site visit. Try refreshing the page after at least 2 minutes.",
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

  static void error(Object? error) {
    if (_context == null) {
      return;
    }
    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(color: ColorScheme.of(context).error),
          ),
          content: Text(
            error?.toString() ?? "An error occurred",
            style: TextStyle(color: ColorScheme.of(context).error),
          ),
        );
      },
    );
  }
}
