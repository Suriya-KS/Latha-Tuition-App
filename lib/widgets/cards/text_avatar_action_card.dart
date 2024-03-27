import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TextAvatarActionCard extends StatelessWidget {
  const TextAvatarActionCard({
    required this.title,
    this.avatarText,
    this.onTap,
    this.action,
    this.children,
    super.key,
  });

  final String title;
  final String? avatarText;
  final List<Widget>? children;
  final Widget? action;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Row(
              children: [
                if (avatarText != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        avatarText!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubtitleText(subtitle: title),
                      if (children != null) const SizedBox(height: 3),
                      if (children != null) ...children!,
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                if (action != null) action!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
