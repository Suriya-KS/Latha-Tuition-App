import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/app_theme.dart';
import 'package:latha_tuition_app/screens/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: "Latha's Tuition App",
        theme: AppTheme.theme,
        themeMode: AppTheme.themeMode,
        home: const Onboarding(),
      ),
    );
  }
}
