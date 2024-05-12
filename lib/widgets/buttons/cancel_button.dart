import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyle(
        side: MaterialStateProperty.all(
            const BorderSide(color: Colors.grey)), // Grey border
      ),
      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
    );
  }
}
