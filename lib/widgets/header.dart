/// Hottest Hundred Heardle
/// header.dart
///
/// The header widget
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

/// Widget for the header of the app. Contains title, drawer, and account icon
class HHHeader extends StatelessWidget {
  static const double _headerHeight = 50.0;

  const HHHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _headerHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        child: _HHTitle(),
      ),
    );
  }
}

/// The title displayed in the header
class _HHTitle extends StatelessWidget {
  static const String _title = "Hottest Hundred Heardle";

  const _HHTitle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
