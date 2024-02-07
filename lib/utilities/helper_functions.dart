import 'package:flutter/material.dart';

import 'package:latha_tuition_app/screens/login.dart';

void navigateToLoginScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ),
  );
}
