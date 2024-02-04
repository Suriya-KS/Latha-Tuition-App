import 'package:flutter/material.dart';

class OnboardingTitleText extends StatelessWidget {
  const OnboardingTitleText({
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
