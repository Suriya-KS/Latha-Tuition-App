import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/screens/authentication/login.dart';
import 'package:latha_tuition_app/screens/student/student_registration.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_new_admissions.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_payment_approval.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/student_fetch_admission_status_sheet.dart';

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

Future<void> navigateToTrackScreen(
  BuildContext context,
  Screen screen,
  Widget destinationScreen,
) async {
  if (screen == Screen.tutorTrackRecordSheet) {
    Navigator.pop(context);
  }

  if (screen == Screen.attendance || screen == Screen.testMarks) {
    Navigator.pop(context);

    return;
  }

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => destinationScreen,
    ),
  );
}

void navigateToStudentRegistrationScreen(
  BuildContext context,
  WidgetRef ref, {
  required Screen screen,
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
  } else if (screen == Screen.login) {
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const StudentRegistrationScreen(),
      ),
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const StudentRegistrationScreen(),
      ),
      (route) => false,
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

Future<void> navigateToTutorPaymentApprovalScreen(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TutorPaymentApprovalScreen(),
    ),
  );
}

void showStudentFetchAdmissionStatusSheet(
  BuildContext context, {
  required Screen screen,
}) {
  if (screen == Screen.onboarding) Navigator.pop(context);

  modalBottomSheet(
    context,
    const StudentFetchAdmissionStatusSheet(),
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

  return dayOfWeekFormatter.format(date).substring(0, 3);
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

String formatAmount(
  num amount, {
  bool includeCurrencySymbol = true,
}) {
  final formatter = NumberFormat('#,##,###.00');
  final formattedAmount = formatter.format(amount);

  if (!includeCurrencySymbol) return formattedAmount;

  return '₹ $formattedAmount';
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

TimeOfDay stringToTimeOfDay(String timeString) {
  List<String> parts = timeString.split(' ');
  List<String> timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  if (parts[1].toLowerCase() == 'pm' && hour != 12) {
    hour += 12;
  } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

TimeOfDay timestampToTimeOfDay(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

Timestamp timeOfDayToTimestamp(DateTime selectedDate, TimeOfDay timeOfDay) {
  final date = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );

  return Timestamp.fromDate(date);
}

Map<String, dynamic> getStudentDetails(WidgetRef ref) {
  final tutorSearchData = ref.read(tutorSearchProvider);

  final studentID = tutorSearchData[TutorSearch.selectedStudentID];
  final List<Map<String, dynamic>> studentsDetails =
      tutorSearchData[TutorSearch.fullStudentDetails];

  final studentDetails = studentsDetails
      .where(
        (studentDetails) => studentDetails['id'] == studentID,
      )
      .first;

  return studentDetails;
}

Color getPaymentContainerColor(BuildContext context, String status) {
  if (status == 'approved') return Theme.of(context).colorScheme.primary;
  if (status == 'rejected') return Theme.of(context).colorScheme.error;

  return Theme.of(context).colorScheme.primary.withOpacity(0.2);
}

IconData getPaymentStatusIcon(String status) {
  if (status == 'approved') return Icons.check;
  if (status == 'rejected') return Icons.close;

  return Icons.timer_outlined;
}

Brightness getThemeMode(BuildContext context) => Theme.of(context).brightness;
