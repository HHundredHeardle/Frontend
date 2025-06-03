/// Hottest Hundred Heardle
/// footer.dart
///
/// The footer widget
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../utils/version.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _ContactInfo(),
            _CommitHash(),
          ],
        ),
      ),
    );
  }
}

/// Text displayed in footer
class _FooterText extends StatelessWidget {
  static const Color _textColor = Colors.grey;

  final String text;

  const _FooterText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.labelSmall?.copyWith(color: _textColor),
    );
  }
}

/// Displays the most recent commit hash or "debug" if not deployed
class _CommitHash extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.only(right: 15.0);

  final String _hash = Version.getCommitHash();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: _padding,
        child: _FooterText(
          _hash,
        ),
      ),
    );
  }
}

/// Displays contact information
class _ContactInfo extends StatelessWidget {
  static const String _email = "hhundredheardle@gmail.com";
  static const String _text = "Contact: ";
  static const EdgeInsets _padding = EdgeInsets.only(left: 15.0);

  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            const _FooterText(
              _text,
            ),
            InkWell(
              child: const _FooterText(
                _email,
              ),
              onTap: () => launchUrl(
                Uri(
                  scheme: "mailto",
                  path: _email,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
