import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/login.dart';
import 'package:latha_tuition_app/screens/sign_up.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';

class RegistrationSheet extends StatelessWidget {
  const RegistrationSheet({
    required this.screen,
    super.key,
  });

  final Screen? screen;

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  void navigateToSignUpScreen(BuildContext context) {
    if (screen == Screen.onboarding) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        ),
      );
    } else {
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(title: 'Start Your Jounery!'),
        const SizedBox(height: 50),
        const PrimaryButton(title: 'Apply for Admission'),
        if (screen == Screen.onboarding)
          InfoActionButton(
            infoText: 'Already part of our academy?',
            buttonText: 'Login here',
            onPressed: () => navigateToLoginScreen(context),
          ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inspired to teach?'),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () => navigateToSignUpScreen(context),
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
