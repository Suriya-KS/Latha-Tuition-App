import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/screens/tutor_dashboard.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class TutorSignUpForm extends ConsumerStatefulWidget {
  const TutorSignUpForm({super.key});

  @override
  ConsumerState<TutorSignUpForm> createState() => _TutorSignUpFormState();
}

class _TutorSignUpFormState extends ConsumerState<TutorSignUpForm> {
  final authentication = FirebaseAuth.instance;
  final tutorsCollectionReference =
      FirebaseFirestore.instance.collection('tutors');
  final formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  late TextEditingController nameController;
  late TextEditingController emailController;
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

  void tutorSignUpHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final userCredentials =
          await authentication.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await tutorsCollectionReference.doc(userCredentials.user!.uid).set({
        'name': nameController.text,
        'emailAddress': emailController.text,
        'phoneNumber': phoneController.text,
      });

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TutorDashboardScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      final errorMessage = validateAuthentication(error);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;
      if (errorMessage == null) return;

      snackBar(
        context,
        content: Text(errorMessage),
      );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
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
          PrimaryButton(
            title: 'Sign Up',
            onPressed: () => tutorSignUpHandler(context),
          ),
        ],
      ),
    );
  }
}
