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
    final screenHeight = MediaQuery.of(context).size.height;
    final totalScreenPadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        screenPadding * 2;

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          screenHeight: screenHeight,
          totalScreenPadding: totalScreenPadding,
          imagePath: handWaveImage,
          title: 'Resume Your Learning',
          descriiption:
              "Welcome back! It's time to resume your academic journey",
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
