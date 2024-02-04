import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/app_theme.dart';
import 'package:latha_tuition_app/screens/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Latha's Tuition App",
      theme: AppTheme.theme,
      themeMode: AppTheme.themeMode,
      home: const Onboarding(),
    );
  }
}
