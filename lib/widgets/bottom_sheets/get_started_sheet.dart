import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/screens/authentication/tutor_sign_up.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';

class GetStartedSheet extends ConsumerWidget {
  const GetStartedSheet({
    required this.screen,
    super.key,
  });

  final Screen screen;

  void navigateToTutorSignUpScreen(BuildContext context) {
    if (screen == Screen.onboarding) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const TutorSignUpScreen(),
        ),
      );
    } else {
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const TutorSignUpScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const TitleText(title: 'Start Your Journey!'),
        const SizedBox(height: 50),
        PrimaryButton(
          title: 'Apply for Admission',
          onPressed: () => navigateToStudentRegistrationScreen(
            context,
            ref,
            screen: screen,
          ),
        ),
        const SizedBox(height: 10),
        InfoActionButton(
          infoText: 'Applied and waiting?',
          buttonText: 'Check status',
          onPressed: () => showStudentFetchAdmissionStatusSheet(
            context,
            screen: Screen.onboarding,
          ),
        ),
        if (screen == Screen.onboarding)
          InfoActionButton(
            infoText: 'Already part of us?',
            buttonText: 'Login here',
            onPressed: () => navigateToLoginScreen(context, screen),
          ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Inspired to teach?'),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () => navigateToTutorSignUpScreen(context),
              child: const Text(
                'Become a Tutor',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: screenPadding),
      ],
    );
  }
}
