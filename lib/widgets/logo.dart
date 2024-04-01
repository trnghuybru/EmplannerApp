import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'EMPLANN',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
          ),
          TextSpan(
            text: 'ER.',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: const Color.fromARGB(255, 250, 187, 24),
                  fontWeight: FontWeight.w900,
                  fontSize: 33,
                ),
          )
        ],
      ),
    );
  }
}
