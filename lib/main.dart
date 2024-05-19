import 'package:emplanner/screens/dashboard.dart';
import 'package:emplanner/screens/register.dart';
import 'package:emplanner/screens/sign_in.dart';
import 'package:emplanner/screens/tabs.dart';
import 'package:emplanner/screens/wellcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
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
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
      ),
      home: const SignInScreen(),
    );
  }
}
