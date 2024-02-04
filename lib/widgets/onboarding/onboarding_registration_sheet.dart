import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/onboarding/onboarding_title_text.dart';

class OnboardingRegistrationSheet extends StatelessWidget {
  const OnboardingRegistrationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OnboardingTitleText(title: 'Start Your Jounery!'),
        const SizedBox(height: 50),
        const PrimaryButton(title: 'Apply for Admission'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already part of our academy?'),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
              onPressed: () => () {},
              child: const Text(
                'Login here',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inspired to teach?'),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Become a Tutor',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
