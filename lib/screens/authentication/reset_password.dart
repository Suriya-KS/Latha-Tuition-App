import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/authentication/reset_password_form.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Reset Your Password',
          description:
              'Reset your password and revive your access to educational empowerment',
          imagePath: confirmImage,
          screenSize: screenSize,
          child: const ResetPasswordForm(),
        ),
      ),
    );
  }
}
