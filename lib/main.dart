import 'package:emplanner/screens/register.dart';
import 'package:emplanner/screens/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 250, 187, 24),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const WellcomeScreen(),
    );
  }
}
