/// Hottest Hundred Heardle
/// main.dart
///
/// Contains the entry point of the application.
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'utils/backend.dart';
import 'utils/game_controller.dart';
import 'widgets/footer.dart';
import 'widgets/header.dart';
import 'widgets/main_panel.dart';

void main() {
  // initialise backend
  Backend();
  // initialise game controller
  GameController().loadGuesses();
  runApp(const HHundredHeardle());
}

class HHundredHeardle extends StatelessWidget {
  static const String _title = 'Hottest Hundred Heardle';

  const HHundredHeardle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.red,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          tertiary: Colors.grey[800],
          primaryContainer: Colors.grey,
          onPrimaryContainer: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(title: _title),
    );
  }
}

class MainPage extends StatelessWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          // title section
          HHHeader(),

          // main content
          Expanded(
            child: HHMainPanel(),
          ),

          // footer
          HHFooter(),
        ],
      ),
    );
  }
}
