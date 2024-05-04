import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/register.dart';
import 'package:emplanner/screens/sign_in.dart';
import 'package:emplanner/screens/tabs.dart';
import 'package:emplanner/screens/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 250, 187, 24),
          surface: const Color.fromARGB(255, 255, 255, 255),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SignInScreen(),
    );
  }
}
