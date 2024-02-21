import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/screens/attendance.dart';
import 'package:latha_tuition_app/screens/test_marks.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_card.dart';

class EventsList extends ConsumerWidget {
  const EventsList({
    required this.items,
    super.key,
  });

  final List<Map<String, dynamic>> items;

  void attendanceCardTapHandler(
    String batchName,
    TimeOfDay startTime,
    TimeOfDay endTime,
    BuildContext context,
    WidgetRef ref,
  ) {
    final trackSheetMethods = ref.read(trackSheetProvider.notifier);
    final attendanceMethods = ref.read(attendanceProvider.notifier);

    trackSheetMethods.setBatchName(batchName);
    trackSheetMethods.setTime(startTime, endTime);
    attendanceMethods.startAttendanceTracker(dummyStudentNames.length);

    navigateToTrackScreen(
      context,
      Screen.calendarView,
      const AttendanceScreen(),
    );
  }

  void testMarksCardTapHandler(
    String testName,
    String batchName,
    TimeOfDay startTime,
    TimeOfDay endTime,
    BuildContext context,
    WidgetRef ref,
  ) {
    final trackSheetMethods = ref.read(trackSheetProvider.notifier);
    final attendanceMethods = ref.read(attendanceProvider.notifier);

    trackSheetMethods.setTestName(testName);
    trackSheetMethods.setBatchName(batchName);
    trackSheetMethods.setTime(startTime, endTime);
    attendanceMethods.startAttendanceTracker(dummyStudentNames.length);

    navigateToTrackScreen(
      context,
      Screen.calendarView,
      const TestMarksScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeToggle =
        ref.watch(calendarViewProvider)[CalendarView.activeToggle];

    Widget content = ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => TextAvatarCard(
        title: items[index]['batchName']!,
        avatarText: items[index]['standard']!,
        onTap: () => attendanceCardTapHandler(
          items[index]['batchName']!,
          items[index]['startTime'],
          items[index]['endTime'],
          context,
          ref,
        ),
        children: [
          Text(
            formatTimeRange(
              items[index]['startTime'],
              items[index]['endTime'],
            ),
          ),
        ],
      ),
    );

    if (activeToggle == CalendarViewToggles.tests) {
      content = ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => TextAvatarCard(
          title: items[index]['testName'],
          avatarText: items[index]['standard']!,
          onTap: () => testMarksCardTapHandler(
            items[index]['testName'],
            items[index]['batchName']!,
            items[index]['startTime'],
            items[index]['endTime'],
            context,
            ref,
          ),
          children: [
            Text(items[index]['batchName']!),
            Text(
              formatTimeRange(
                items[index]['startTime'],
                items[index]['endTime'],
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: content,
      ),
    );
  }
}
