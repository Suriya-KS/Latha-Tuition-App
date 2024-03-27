import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/screens/authentication/login.dart';
import 'package:latha_tuition_app/screens/student/student_registration.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_new_admissions.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_payment_approval.dart';

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

void navigateToTrackScreen(
  BuildContext context,
  Screen screen,
  Widget destinationScreen,
) {
  if (screen == Screen.tutorTrackRecordSheet) {
    Navigator.pop(context);
  }

  if (screen == Screen.attendance || screen == Screen.testMarks) {
    Navigator.pop(context);

    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => destinationScreen,
    ),
  );
}

void navigateToStudentRegistrationScreen(
  BuildContext context,
  WidgetRef ref, {
  Screen? screen,
}) {
  final loadingMethods = ref.read(loadingProvider.notifier);

  loadingMethods.setLoadingStatus(true);

  if (screen == Screen.onboarding) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const StudentRegistrationScreen(),
      ),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const StudentRegistrationScreen(),
      ),
    );
  }
}

Future<void> navigateToTutorNewAdmissionsScreen(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TutorNewAdmissionsScreen(),
    ),
  );
}

void navigateToTutorPaymentApprovalScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TutorPaymentApprovalScreen(),
    ),
  );
}

Future<UserType?> getAuthenticatedUserType(
  BuildContext context,
  String userID,
) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final studentDocumentSnapshot =
        await firestore.collection('students').doc(userID).get();

    if (studentDocumentSnapshot.exists) return UserType.student;

    final tutorDocumentSnapshot =
        await firestore.collection('tutors').doc(userID).get();

    if (tutorDocumentSnapshot.exists) return UserType.tutor;

    return null;
  } catch (error) {
    if (!context.mounted) return null;

    snackBar(
      context,
      content: const Text(defaultErrorMessage),
    );

    return null;
  }
}

String formatName(String name) {
  final firstName = name.split(' ')[0];

  if (firstName.length <= 7) return 'Hi, $firstName';

  String shortenedName = '${firstName.substring(0, 7)}...';

  return 'Hi, $shortenedName';
}

String formatDate(DateTime date) {
  final formatter = DateFormat('MMMM d, yyyy');

  return formatter.format(date);
}

String formatDateDay(DateTime date) {
  final monthFormatter = DateFormat.MMMM();
  final dayFormatter = DateFormat.d();
  final dayOfWeekFormatter = DateFormat.E();

  final month = monthFormatter.format(date);
  final day = dayFormatter.format(date);
  final dayOfWeek = dayOfWeekFormatter.format(date);

  return '$month $day, $dayOfWeek';
}

String formatShortenDay(DateTime date) {
  final dayOfWeekFormatter = DateFormat.E();

  return dayOfWeekFormatter.format(date).substring(0, 2);
}

String formatTime(TimeOfDay time) {
  String hours =
      (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(2, '0');
  String minutes = time.minute.toString().padLeft(2, '0');
  String period = time.period == DayPeriod.am ? 'am' : 'pm';

  return '$hours:$minutes $period';
}

String formatTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
  String startHours = (startTime.hour % 12 == 0 ? 12 : startTime.hour % 12)
      .toString()
      .padLeft(2, '0');
  String startMinutes = startTime.minute.toString().padLeft(2, '0');
  String endHours = (endTime.hour % 12 == 0 ? 12 : endTime.hour % 12)
      .toString()
      .padLeft(2, '0');
  String endMinutes = endTime.minute.toString().padLeft(2, '0');
  String startPeriod = startTime.period == DayPeriod.am ? 'am' : 'pm';
  String endPeriod = endTime.period == DayPeriod.am ? 'am' : 'pm';

  return '$startHours:$startMinutes $startPeriod - $endHours:$endMinutes $endPeriod';
}

String formatMarks(double marks) {
  if (marks % 1 == 0) {
    return marks.toInt().toString();
  }

  return marks.toStringAsFixed(2);
}

String formatAmount(num amount) {
  final formatter = NumberFormat('#,##,###.00');

  return '₹ ${formatter.format(amount)}';
}

String capitalizeText(String text) {
  List<String> words = text.split(' ');

  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
  }

  return words.join(' ');
}

void attendanceStatusToggleHandler(
  int toggleIndex,
  int listIndex,
  WidgetRef ref,
) {
  final attendanceMethods = ref.read(attendanceProvider.notifier);

  if (toggleIndex == 0) {
    attendanceMethods.trackAttendance(listIndex, 'present');
  }

  if (toggleIndex == 1) {
    attendanceMethods.trackAttendance(listIndex, 'absent');
  }
}
