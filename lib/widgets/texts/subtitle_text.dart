import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    required this.subtitle,
    this.color,
    super.key,
  });

  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
