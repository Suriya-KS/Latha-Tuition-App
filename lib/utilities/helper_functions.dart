import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/login.dart';

void navigateToLoginScreen(BuildContext context, Screen? screen) {
  if (screen == Screen.onboarding) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }
}
