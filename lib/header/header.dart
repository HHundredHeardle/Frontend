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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _HHAccountAvatar(_headerHeight),
            _HHTitle(),
            const _HHDrawerButton(_headerHeight),
          ],
        ),
      ),
    );
  }
}

/// The title displayed in the header
class _HHTitle extends StatelessWidget {
  static const String _title = "Hottest Hundred Heardle";

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

/// Button/Icon for account
class _HHAccountAvatar extends StatelessWidget {
  final double _headerHeight;

  const _HHAccountAvatar(double headerHeight) : _headerHeight = headerHeight;

  @override
  Widget build(BuildContext context) {
    return _HeaderChildCentrer(
      headerHeight: _headerHeight,
      child: IconButton(
        onPressed: () {},
        icon: _HHHeaderIcon(
          icon: Icons.account_circle,
          headerHeight: _headerHeight,
        ),
      ),
    );
  }
}

/// Drawer Button
class _HHDrawerButton extends StatelessWidget {
  final double _headerHeight;

  const _HHDrawerButton(double headerHeight) : _headerHeight = headerHeight;

  @override
  Widget build(BuildContext context) {
    return _HeaderChildCentrer(
      headerHeight: _headerHeight,
      child: IconButton(
        onPressed: () {},
        icon: _HHHeaderIcon(
          icon: Icons.menu,
          headerHeight: _headerHeight,
        ),
      ),
    );
  }
}

/// Layout widget to set icon sizes
class _HHHeaderIcon extends Icon {
  /// proportion of header height size of icon will be
  static const double _sizeRatio = 0.5;

  const _HHHeaderIcon({required IconData icon, required double headerHeight})
      : super(
          icon,
          size: (headerHeight * _sizeRatio),
        );
}

/// SizedBox that ensures children are centred in the space they occupy in the
/// header
class _HeaderChildCentrer extends StatelessWidget {
  /// Height of the header this widget is placed inside of
  final double _headerHeight;
  final Widget child;

  const _HeaderChildCentrer({required double headerHeight, required this.child})
      : _headerHeight = headerHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _headerHeight,
      child: child,
    );
  }
}
