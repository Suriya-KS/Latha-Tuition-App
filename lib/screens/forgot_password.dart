import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/forgot_password/send_verification_code_form.dart';
import 'package:latha_tuition_app/widgets/forgot_password/verify_code_form.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context);

    final forgotPasswordData = ref.watch(forgotPasswordProvider);
    final activeForm = forgotPasswordData[ForgotPassword.activeForm];
    final inputText = forgotPasswordData[ForgotPassword.inputText];

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Recover Your Account',
          description:
              "Forgotten your password? No worries! We'll assist you in resetting it securely",
          imagePath: forgotPasswordImage,
          screenSize: screenSize,
          child: Column(
            children: [
              if (activeForm == ForgotPasswordForm.sendVerificationCode)
                const SendVerificationCodeForm(),
              if (activeForm == ForgotPasswordForm.verifyCode &&
                  inputText != '')
                const VerifyCodeForm(),
            ],
          ),
        ),
      ),
    );
  }
}
