import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/widgets/onboarding/onboarding_title_text.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.image,
    required this.title,
    required this.contents,
    required this.color,
    super.key,
  });

  final String image;
  final String title;
  final List<Widget> contents;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      color: color,
      child: Column(
        children: [
          SizedBox(height: statusBarHeight + screenHeight * 0.05),
          SvgPicture.asset(
            image,
            height: screenHeight * 0.4,
          ),
          SizedBox(height: screenHeight * 0.1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingTitleText(title: title),
              const SizedBox(height: 10),
              ...contents,
            ],
          ),
        ],
      ),
    );
  }
}
