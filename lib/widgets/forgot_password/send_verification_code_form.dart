import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class SendVerificationCodeForm extends ConsumerStatefulWidget {
  const SendVerificationCodeForm({super.key});

  @override
  ConsumerState<SendVerificationCodeForm> createState() =>
      _SendVerificationCodeFormState();
}

class _SendVerificationCodeFormState
    extends ConsumerState<SendVerificationCodeForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController controller;

  void submitFormHandler() {
    if (formKey.currentState!.validate()) {
      ref
          .read(forgotPasswordProvider.notifier)
          .switchToVerifyCodeForm(controller.text);
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordData = ref.watch(forgotPasswordProvider);
    final recoveryMethod = forgotPasswordData[ForgotPassword.recoveryMethod];

    String labelText = 'Email Address';
    IconData prefixIcon = Icons.mail_outline;
    TextInputType inputType = TextInputType.emailAddress;
    String? Function(String?) validator = validateEmail;

    if (recoveryMethod == PasswordRecoveryMethod.sms) {
      labelText = 'Phone Number';
      prefixIcon = Icons.phone_outlined;
      inputType = TextInputType.number;
      validator = validatePhoneNumber;
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextInput(
            labelText: labelText,
            prefixIcon: prefixIcon,
            prefixText:
                recoveryMethod == PasswordRecoveryMethod.sms ? '+91 ' : null,
            inputType: inputType,
            controller: controller,
            validator: validator,
          ),
          const SizedBox(height: 50),
          PrimaryButton(
            title: 'Send Verification Code',
            onPressed: submitFormHandler,
          ),
        ],
      ),
    );
  }
}
