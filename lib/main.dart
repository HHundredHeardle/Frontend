/// Hottest Hundred Heardle
/// main.dart
///
/// Contains the entry point of the application.
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'account.dart';
import 'backend.dart';
import 'footer.dart';
import 'header.dart';
import 'main_panel.dart';
import 'menu.dart';

void main() {
  // initialise backend
  Backend();
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

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          // title section
          HHHeader(),

          // main content
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: HHAccountPanel(),
                ),
                Expanded(
                  child: HHMainPanel(),
                ),
                Expanded(
                  child: HHMenuPanel(),
                ),
              ],
            ),
          ),

          // footer
          HHFooter(),
        ],
      ),
    );
  }
}
