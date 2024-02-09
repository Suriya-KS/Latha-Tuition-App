import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

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
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
