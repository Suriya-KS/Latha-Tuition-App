import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/tutor_sign_up/tutor_sign_up_form.dart';

class TutorSignUpScreen extends StatelessWidget {
  const TutorSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Teaching with Impact',
          description:
              "Transform lives and shape minds by teaching with impact, leaving a lasting educational imprint",
          imagePath: handshakeImage,
          screenSize: screenSize,
          child: Column(
            children: [
              const TutorSignUpForm(),
              const SizedBox(height: 10),
              InfoActionButton(
                infoText: 'Already joined?',
                buttonText: 'Login here',
                onPressed: () => navigateToLoginScreen(context, Screen.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
