import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class StudentSignUpForm extends StatefulWidget {
  const StudentSignUpForm({super.key});

  @override
  State<StudentSignUpForm> createState() => _StudentSignUpFormState();
}

class _StudentSignUpFormState extends State<StudentSignUpForm> {
  final formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

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
  void initState() {
    super.initState();

    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
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
