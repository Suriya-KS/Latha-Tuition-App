import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/forgot_password/send_verification_code_form.dart';
import 'package:latha_tuition_app/widgets/forgot_password/verify_code_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    required this.recoveryMethod,
    super.key,
  });

  final PasswordRecoveryMethod recoveryMethod;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String inputText = '';
  ForgotPasswordForm activeForm = ForgotPasswordForm.sendVerificationCode;

  void changeActiveForm(String enteredInputText) {
    setState(() {
      inputText = enteredInputText;
      activeForm = ForgotPasswordForm.verifyCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Recover Your Account',
          description:
              "Forgotten your password? No worries! We'll assist you in resetting it securely",
          imagePath: forgotPasswordImage,
          screenSize: screenSize,
          child: Column(children: [
            if (activeForm == ForgotPasswordForm.sendVerificationCode)
              SendVerificationCodeForm(
                recoveryMethod: widget.recoveryMethod,
                changeActiveForm: changeActiveForm,
              ),
            if (activeForm == ForgotPasswordForm.verifyCode && inputText != '')
              VerifyCodeForm(
                recoveryMethod: widget.recoveryMethod,
                inputText: inputText,
              )
          ]),
        ),
      ),
    );
  }
}
