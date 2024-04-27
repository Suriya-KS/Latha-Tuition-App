import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:latha_tuition_app/firebase_options.dart';
import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/app_theme.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/screens/splash.dart';
import 'package:latha_tuition_app/screens/onboarding.dart';
import 'package:latha_tuition_app/screens/student/student_awaiting_approval.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_dashboard.dart';
import 'package:latha_tuition_app/screens/student/student_dashboard.dart';
import 'package:latha_tuition_app/screens/offline_error.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final authenticatedUser = FirebaseAuth.instance.currentUser;

  late Widget screen = const SplashScreen();

  Future<Widget> loadScreen(BuildContext context) async {
    try {
      await ref.read(awaitingAdmissionProvider.notifier).loadStudentID();

      final awaitingAdmissionStudentID =
          ref.read(awaitingAdmissionProvider)[AwaitingAdmission.studentID];

      if (awaitingAdmissionStudentID != null) {
        return const StudentAwaitingApprovalScreen();
      }

      if (authenticatedUser == null) {
        return const OnboardingScreen();
      }

      if (!context.mounted) throw Error();

      final userID = authenticatedUser!.uid;

      final userType = await getAuthenticatedUserType(
        context,
        userID,
      );

      final authenticationMethods = ref.read(authenticationProvider.notifier);

      if (userType == UserType.student) {
        authenticationMethods.setStudentID(userID);

        return const StudentDashboardScreen();
      }

      if (userType == UserType.tutor) {
        authenticationMethods.setTutorID(userID);

        return const TutorDashboardScreen();
      }

      authenticationMethods.clearStudentID();

      return OfflineErrorScreen(onRetry: loadScreen);
    } catch (error) {
      return OfflineErrorScreen(onRetry: loadScreen);
    }
  }

  void initializeApp() async {
    final result = await Future.wait([
      loadScreen(context),
      Future.delayed(splashLoadingVideoDuration),
    ]);

    setState(() {
      screen = result[0];
    });
  }

  @override
  void initState() {
    super.initState();

    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Latha's Tuition App",
      theme: AppTheme.theme,
      themeMode: AppTheme.themeMode,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: screen,
    );
  }
}
