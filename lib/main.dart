import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/firebase_options.dart';
import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/app_theme.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/screens/onboarding.dart';
import 'package:latha_tuition_app/screens/student/student_awaiting_approval.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final authenticatedUser = FirebaseAuth.instance.currentUser;

  Widget screen = const Placeholder();

  void loadScreen(BuildContext context) async {
    try {
      await ref.read(awaitingAdmissionProvider.notifier).loadStudentID();

      final awaitingAdmissionStudentID =
          ref.read(awaitingAdmissionProvider)[AwaitingAdmission.studentID];

      if (awaitingAdmissionStudentID != null) {
        setState(() {
          screen = const StudentAwaitingApprovalScreen();
        });

        return;
      }

      if (authenticatedUser == null) {
        setState(() {
          screen = const OnboardingScreen();
        });

        return;
      }

      if (!context.mounted) return;

      final userType = await getAuthenticatedUserType(
        context,
        authenticatedUser!.uid,
      );

      if (userType == UserType.student) {
        setState(() {
          screen = const Placeholder();
        });

        return;
      }

      if (userType == UserType.tutor) {
        setState(() {
          screen = const TutorDashboardScreen();
        });

        return;
      }

      setState(() {
        screen = const Placeholder();
      });
    } catch (error) {
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

    loadScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Latha's Tuition App",
      theme: AppTheme.theme,
      themeMode: AppTheme.themeMode,
      home: screen,
    );
  }
}
