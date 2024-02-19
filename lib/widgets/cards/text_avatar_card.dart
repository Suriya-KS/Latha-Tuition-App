import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TextAvatarCard extends StatelessWidget {
  const TextAvatarCard({
    required this.title,
    required this.avatarText,
    required this.children,
    super.key,
  });

  final String title;
  final String avatarText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Text(
                  avatarText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleText(subtitle: title),
                    const SizedBox(height: 3),
                    ...children
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
