import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TextStatusActionsCard extends StatelessWidget {
  const TextStatusActionsCard({
    required this.title,
    required this.description,
    required this.onApproveTap,
    required this.onRejectTap,
    super.key,
  });

  final String title;
  final Widget description;
  final void Function() onApproveTap;
  final void Function() onRejectTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleText(subtitle: title),
                  description,
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: onApproveTap,
                    icon: const Icon(Icons.check_outlined),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: onRejectTap,
                    icon: const Icon(Icons.close_outlined),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
