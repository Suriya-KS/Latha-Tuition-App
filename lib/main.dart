import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/firebase_options.dart';
import 'package:latha_tuition_app/utilities/app_theme.dart';
import 'package:latha_tuition_app/screens/tutor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        home: const TutorDashboardScreen(),
      ),
    );
  }
}
