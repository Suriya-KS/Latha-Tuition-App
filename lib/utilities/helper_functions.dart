import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
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

void navigateToTrackScreen(
  BuildContext context,
  Screen screen,
  Widget destinationScreen,
) {
  if (screen == Screen.trackRecordSheet) {
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

String formatDate(DateTime date) {
  final formatter = DateFormat('MMMM d, yyyy');
  return formatter.format(date);
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
