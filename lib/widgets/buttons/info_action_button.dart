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
        Flexible(
          child: Text(infoText),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            child: Text(
              buttonText,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
