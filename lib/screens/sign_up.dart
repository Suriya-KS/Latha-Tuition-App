import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/login.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/sign_up/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final totalScreenPadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        screenPadding * 2;

    void navigateToLoginScreen(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          screenHeight: screenHeight,
          totalScreenPadding: totalScreenPadding,
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
                  onPressed: () => navigateToLoginScreen(context)),
            ],
          ),
        ),
      ),
    );
  }
}
