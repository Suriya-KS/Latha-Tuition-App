import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class SendVerificationCodeForm extends StatefulWidget {
  const SendVerificationCodeForm({
    required this.recoveryMethod,
    required this.changeActiveForm,
    super.key,
  });

  final PasswordRecoveryMethod recoveryMethod;
  final void Function(String) changeActiveForm;

  @override
  State<SendVerificationCodeForm> createState() =>
      _SendVerificationCodeFormState();
}

class _SendVerificationCodeFormState extends State<SendVerificationCodeForm> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  void submitFormHandler() {
    if (formKey.currentState!.validate()) {
      widget.changeActiveForm(controller.text);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String labelText = 'Email Address';
    IconData prefixIcon = Icons.mail_outline;
    TextInputType inputType = TextInputType.emailAddress;
    String? Function(String?) validator = validateEmail;

    if (widget.recoveryMethod == PasswordRecoveryMethod.sms) {
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
            prefixText: widget.recoveryMethod == PasswordRecoveryMethod.sms
                ? '+91 '
                : null,
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
