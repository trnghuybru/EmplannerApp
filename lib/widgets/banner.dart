import 'package:flutter/material.dart';

class DashboardBanner extends StatelessWidget {
  const DashboardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 184, 0),
            Color.fromARGB(255, 255, 225, 120)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    );
  }
}
