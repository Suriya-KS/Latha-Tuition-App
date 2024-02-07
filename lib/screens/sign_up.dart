import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/sign_up/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          screenSize: screenSize,
          imagePath: handshakeImage,
          title: 'Teaching with Impact',
          descriiption:
              "Transform lives and shape minds by teaching with impact, leaving a lasting educational imprint",
          child: Column(
            children: [
              const SignUpForm(),
              InfoActionButton(
                infoText: 'Already joined?',
                buttonText: 'Login here',
                onPressed: () => navigateToLoginScreen(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
