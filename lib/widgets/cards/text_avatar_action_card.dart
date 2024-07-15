import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/utilities/card_floating_icon.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TextAvatarActionCard extends StatefulWidget {
  const TextAvatarActionCard({
    this.title,
    this.avatarText,
    this.onTap,
    this.action,
    this.icon,
    this.iconOnTap,
    this.children,
    super.key,
  });

  final String? title;
  final String? avatarText;
  final List<Widget>? children;
  final Widget? action;
  final IconData? icon;
  final void Function()? iconOnTap;
  final void Function()? onTap;

  @override
  State<TextAvatarActionCard> createState() => _TextAvatarActionCardState();
}

class _TextAvatarActionCardState extends State<TextAvatarActionCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    if (widget.avatarText != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            widget.avatarText!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null)
                            SubtitleText(subtitle: widget.title!),
                          if (widget.children != null)
                            const SizedBox(height: 3),
                          if (widget.children != null) ...widget.children!,
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (widget.action != null) widget.action!,
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.icon != null)
          CardFloatingIcon(
            icon: widget.icon!,
            color: Theme.of(context).colorScheme.error,
            iconPosition: 'right',
            isClickable: true,
            onTap: widget.iconOnTap,
          ),
      ],
    );
  }
}
