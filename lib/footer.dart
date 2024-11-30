/// Hottest Hundred Heardle
/// footer.dart
///
/// The footer widget
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

/// Footer displayed at bottom of page
class HHFooter extends StatelessWidget {
  static const double _footerHeight = 40.0;

  const HHFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _footerHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
