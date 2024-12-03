/// Hottest Hundred Heardle
/// footer.dart
///
/// The footer widget
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'version.dart';

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
        child: _CommitHash(),
      ),
    );
  }
}

/// Displays the most recent commit hash or "debug" if not deployed
class _CommitHash extends StatelessWidget {
  final String _hash = Version.commitHash;
  final Color _textColor = Colors.grey;
  final EdgeInsets _padding = const EdgeInsets.only(right: 15.0);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: _padding,
        child: Text(
          _hash,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: _textColor),
        ),
      ),
    );
  }
}
