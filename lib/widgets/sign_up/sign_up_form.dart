import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      passwordObscureText = !passwordObscureText;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      confirmPasswordObscureText = !confirmPasswordObscureText;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextInput(
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            inputType: TextInputType.name,
            controller: nameController,
            validator: validateName,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outline,
            inputType: TextInputType.emailAddress,
            controller: emailController,
            validator: validateEmail,
          ),
          const SizedBox(height: 10),
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
            suffixIcon: passwordObscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconOnPressed: togglePasswordVisibility,
            obscureText: passwordObscureText,
            inputType: TextInputType.visiblePassword,
            controller: passwordController,
            validator: validatePassword,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            suffixIcon: confirmPasswordObscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconOnPressed: toggleConfirmPasswordVisibility,
            obscureText: confirmPasswordObscureText,
            inputType: TextInputType.visiblePassword,
            controller: confirmPasswordController,
            validator: (value) => validateConfirmPassword(
              value,
              passwordController.text,
            ),
          ),
          const SizedBox(height: 50),
          const PrimaryButton(title: 'Sign Up'),
        ],
      ),
    );
  }
}
