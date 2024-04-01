import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function() onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 250, 187, 24),
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
