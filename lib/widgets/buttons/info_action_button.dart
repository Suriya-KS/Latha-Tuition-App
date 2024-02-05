import 'package:flutter/material.dart';

class InfoActionButton extends StatelessWidget {
  const InfoActionButton({
    required this.infoText,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final String infoText;
  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(infoText),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 5),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
