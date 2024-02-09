import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/registration_sheet.dart';
import 'package:latha_tuition_app/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Resume Your Learning',
          description:
              "Welcome back! It's time to resume your academic journey",
          imagePath: handWaveImage,
          screenSize: screenSize,
          child: Column(
            children: [
              const LoginForm(),
              InfoActionButton(
                infoText: 'New here?',
                buttonText: 'Join Us',
                onPressed: () => modalBottomSheet(
                  context,
                  const RegistrationSheet(screen: Screen.login),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
