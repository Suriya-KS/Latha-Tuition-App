import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}
