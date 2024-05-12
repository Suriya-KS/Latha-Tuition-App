import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class IconWithTextButton extends StatelessWidget {
  const IconWithTextButton({
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 60,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleText(subtitle: title),
                Text(description),
              ],
            )
          ],
        ),
      ),
    );
  }
}
