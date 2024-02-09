import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  bool obscureText = true;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextInput(
            labelText: 'Phone Number',
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            controller: phoneController,
            validator: validatePhoneNumber,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Password',
            prefixIcon: Icons.lock_outline,
            suffixIcon: obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconOnPressed: togglePasswordVisibility,
            obscureText: obscureText,
            inputType: TextInputType.visiblePassword,
            controller: passwordController,
            validator: validatePassword,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 30),
          const PrimaryButton(title: 'Login'),
        ],
      ),
    );
  }
}
