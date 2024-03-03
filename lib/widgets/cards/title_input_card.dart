import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TitleInputCard extends StatelessWidget {
  const TitleInputCard({
    required this.title,
    required this.input,
    this.description,
    super.key,
  });

  final String title;
  final Widget input;
  final String? description;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleText(subtitle: title),
                    if (description != null) Text(description!),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              input,
            ],
          ),
        ),
        // child: Text(name),
      ),
    );
  }
}
