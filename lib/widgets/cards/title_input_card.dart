import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class TitleInputCard extends StatelessWidget {
  const TitleInputCard({
    required this.title,
    required this.input,
    super.key,
  });

  final String title;
  final Widget input;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SubtitleText(subtitle: title),
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
