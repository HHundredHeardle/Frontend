/// Hottest Hundred Heardle
/// conditional_scroll_view.dart.dart
///
/// Makes content scrollable if it exceeds the vertical viewport
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

/// Makes child scrollable iff content is too large to display on screen
class ConditionalScrollView extends StatelessWidget {
  final Widget child;

  const ConditionalScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        ),
      ],
    );
  }
}
