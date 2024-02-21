import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.title,
    this.iconData,
    this.onPressed,
    super.key,
  });

  final String? title;
  final IconData? iconData;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      onPressed: onPressed ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            if (title != null && iconData != null) const SizedBox(width: 10),
            if (iconData != null)
              Icon(
                iconData,
                size: 30,
              ),
          ],
        ),
      ),
    );
  }
}
