import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon, // Optional icon parameter
  });

  final Function() onPressed;
  final Widget title;
  final IconData? icon; // Nullable type for icon

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox(),
      label: title,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 250, 187, 24),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
      ),
    );
  }
}
