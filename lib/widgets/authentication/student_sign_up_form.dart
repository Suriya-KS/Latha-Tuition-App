import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/providers/admission_provider.dart';
import 'package:latha_tuition_app/screens/student/student_dashboard.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class StudentSignUpForm extends ConsumerStatefulWidget {
  const StudentSignUpForm({super.key});

  @override
  ConsumerState<StudentSignUpForm> createState() => _StudentSignUpFormState();
}

class _StudentSignUpFormState extends ConsumerState<StudentSignUpForm> {
  final authentication = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  late String emailAddress;
  late TextEditingController emailController;
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

  void studentSignUpHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final loadingMethods = ref.read(loadingProvider.notifier);
    final authenticationMethods = ref.read(authenticationProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final userCredentials =
          await authentication.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final studentID = userCredentials.user!.uid;

      final Map<String, dynamic> studentDetails =
          ref.read(admissionProvider)[Admission.studentDetails];

      studentDetails.remove('awaitingApproval');
      studentDetails.remove('requestedAt');

      await firestore.collection('students').doc(studentID).set({
        ...studentDetails,
      });

      final awaitingAdmissionStudentID =
          ref.read(awaitingAdmissionProvider)[AwaitingAdmission.studentID];

      await firestore
          .collection('studentAdmissionRequests')
          .doc(awaitingAdmissionStudentID)
          .delete();

      await ref.read(awaitingAdmissionProvider.notifier).clearData();

      authenticationMethods.setStudentID(studentID);
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentDashboardScreen(),
        ),
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

    emailAddress =
        ref.read(admissionProvider)[Admission.studentDetails]['emailAddress'];

    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
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
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outline,
            inputType: TextInputType.emailAddress,
            initialValue: emailAddress,
            readOnly: true,
            controller: emailController,
            validator: validateEmail,
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
            onPressed: () => studentSignUpHandler(context),
          ),
        ],
      ),
    );
  }
}
