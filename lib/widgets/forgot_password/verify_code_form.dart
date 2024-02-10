import 'dart:async';

import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/reset_password.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/verification_code_input.dart';

class VerifyCodeForm extends StatefulWidget {
  const VerifyCodeForm({
    required this.inputText,
    required this.recoveryMethod,
    super.key,
  });

  final String inputText;
  final PasswordRecoveryMethod recoveryMethod;

  @override
  State<VerifyCodeForm> createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  final formKey = GlobalKey<FormState>();

  late Timer timer;

  bool canResend = false;
  int secondsRemaining = passwordVerificationCodeResendTime.inSeconds;

  final verificationCode1Controller = TextEditingController();
  final verificationCode2Controller = TextEditingController();
  final verificationCode3Controller = TextEditingController();
  final verificationCode4Controller = TextEditingController();

  final verificationCode1FocusNode = FocusNode();

  void resendTimerHandler() {
    verificationCode1Controller.clear();
    verificationCode2Controller.clear();
    verificationCode3Controller.clear();
    verificationCode4Controller.clear();

    verificationCode1FocusNode.requestFocus();

    setState(() {
      canResend = false;
      secondsRemaining = passwordVerificationCodeResendTime.inSeconds;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        canResend = true;
        secondsRemaining = 0;
      }
    });
  }

  void navigateToResetPasswordScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const ResetPassword(),
      ),
    );
  }

  void submitFormHandler() {
    navigateToResetPasswordScreen();
  }

  @override
  void initState() {
    super.initState();
    resendTimerHandler();
  }

  @override
  void dispose() {
    verificationCode1Controller.dispose();
    verificationCode2Controller.dispose();
    verificationCode3Controller.dispose();
    verificationCode4Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    String formattedText = widget.inputText;

    if (widget.recoveryMethod == PasswordRecoveryMethod.sms) {
      formattedText = '+91 ${widget.inputText}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter the verification code sent to'),
        Text(
          formattedText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VerificationCodeInput(
                    screenSize: screenSize,
                    focusNode: verificationCode1FocusNode,
                    controller: verificationCode1Controller,
                  ),
                  VerificationCodeInput(
                    screenSize: screenSize,
                    controller: verificationCode2Controller,
                  ),
                  VerificationCodeInput(
                    screenSize: screenSize,
                    controller: verificationCode3Controller,
                  ),
                  VerificationCodeInput(
                    screenSize: screenSize,
                    controller: verificationCode4Controller,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    onPressed:
                        secondsRemaining == 0 ? resendTimerHandler : null,
                    child: const Text('Resend Code'),
                  ),
                  secondsRemaining > 0
                      ? Text('in $secondsRemaining seconds')
                      : const Text(''),
                ],
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                title: 'Verify',
                onPressed: submitFormHandler,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
