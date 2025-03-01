import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/screens/authentication/forgot_password.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_dashboard.dart';
import 'package:latha_tuition_app/screens/student/student_dashboard.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final authentication = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  bool obscureText = true;
  ScaffoldMessengerState? scaffoldMessengerState;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void loginHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final loadingMethods = ref.read(loadingProvider.notifier);
    final authenticationMethods = ref.read(authenticationProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final userCredentials = await authentication.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredentials.user == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      if (!context.mounted) return;

      final userID = userCredentials.user!.uid;

      final userType = await getAuthenticatedUserType(context, userID);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      if (userType == UserType.student) {
        authenticationMethods.setStudentID(userID);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentDashboardScreen(),
          ),
          (route) => false,
        );
      } else if (userType == UserType.tutor) {
        authenticationMethods.setTutorID(userID);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TutorDashboardScreen()),
          (route) => false,
        );
      } else {
        throw FirebaseAuthException(code: 'user-not-found');
      }
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

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    scaffoldMessengerState?.hideCurrentSnackBar();

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
            controller: emailController,
            validator: validateEmail,
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const ForgotPasswordScreen(),
                ),
              ),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            title: 'Login',
            onPressed: () => loginHandler(context),
          ),
        ],
      ),
    );
  }
}
