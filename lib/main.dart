/// Hottest Hundred Heardle
/// main.dart
///
/// Contains the entry point of the application.
///
/// Authors: Joshua Linehan
library;

import 'package:flutter/material.dart';

import 'footer.dart';

void main() {
  runApp(const HHundredHeardle());
}

class HHundredHeardle extends StatelessWidget {
  const HHundredHeardle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const MainPage(title: 'Hottest Hundred Heardle'),
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
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // title section
          SizedBox(
            height: 100.0,
            child: Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          // main content
          Expanded(
            child: Center(
              child: Text(
                "Hottest Hundred Heardle is currently under construction",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.yellow.withOpacity(0.75)),
              ),
            ),
          ),

          // footer
          const HHFooter(),
        ],
      ),
    );
  }
}
