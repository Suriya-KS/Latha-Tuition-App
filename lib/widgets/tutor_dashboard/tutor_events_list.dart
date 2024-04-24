import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_track_attendance.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_track_test_marks.dart';
import 'package:latha_tuition_app/widgets/utilities/percent_indicator.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class TutorEventsList extends ConsumerWidget {
  const TutorEventsList({
    required this.items,
    this.onUpdate,
    super.key,
  });

  final List<Map<String, dynamic>> items;
  final void Function()? onUpdate;

  int countPresentStudents(List<Map<String, dynamic>> studentList) {
    int presentCount = 0;

    for (var student in studentList) {
      if (student['status'] == 'present') {
        presentCount++;
      }
    }

    return presentCount;
  }

  num countStudentsAverageMarks(List<Map<String, dynamic>> studentList) {
    num studentsMarks = 0;

    for (var student in studentList) {
      studentsMarks += student['marks'];
    }

    return studentsMarks / studentList.length;
  }

  void attendanceCardTapHandler(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String batchName,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required List<Map<String, dynamic>> attendance,
  }) async {
    final trackSheetMethods = ref.read(trackSheetProvider.notifier);

    trackSheetMethods.setIsBatchNameEditable(false);
    trackSheetMethods.setBatchName(batchName);
    trackSheetMethods.setTime(startTime, endTime);
    trackSheetMethods.setSelectedAttendanceID(id);

    await navigateToTrackScreen(
      context,
      Screen.tutorEventsView,
      TutorTrackAttendanceScreen(
        attendanceList: attendance,
      ),
    );

    if (onUpdate != null) onUpdate!();
  }

  void testMarksCardTapHandler(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String testName,
    required String batchName,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required List<Map<String, dynamic>> testMarks,
    required num totalMarks,
  }) async {
    final trackSheetMethods = ref.read(trackSheetProvider.notifier);

    trackSheetMethods.setIsBatchNameEditable(false);
    trackSheetMethods.setTestName(testName);
    trackSheetMethods.setBatchName(batchName);
    trackSheetMethods.setTime(startTime, endTime);
    trackSheetMethods.setTotalMarks(totalMarks);
    trackSheetMethods.setSelectedTestMarksID(id);

    await navigateToTrackScreen(
      context,
      Screen.tutorEventsView,
      TutorTrackTestMarksScreen(
        testMarks: testMarks,
      ),
    );

    if (onUpdate != null) onUpdate!();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeToggle =
        ref.watch(calendarViewProvider)[CalendarView.activeToggle];

    Widget content = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length + 1,
      itemBuilder: (context, index) => index < items.length
          ? TextAvatarActionCard(
              title: items[index]['batchName'],
              onTap: () => attendanceCardTapHandler(
                context,
                ref,
                id: items[index]['id'],
                batchName: items[index]['batchName'],
                startTime: items[index]['startTime'],
                endTime: items[index]['endTime'],
                attendance: List<Map<String, dynamic>>.from(
                  items[index]['attendance'],
                ),
              ),
              action: PercentIndicator(
                currentValue: countPresentStudents(
                  List<Map<String, dynamic>>.from(items[index]['attendance']),
                ),
                totalValue: items[index]['attendance'].length,
              ),
              children: [
                Text(formatDateDay(items[index]['date'])),
                Text(
                  formatTimeRange(
                    items[index]['startTime'],
                    items[index]['endTime'],
                  ),
                ),
              ],
            )
          : const SizedBox(height: 120),
    );

    if (activeToggle == CalendarViewToggles.tests) {
      content = ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => index < items.length
            ? TextAvatarActionCard(
                title: items[index]['name'],
                onTap: () => testMarksCardTapHandler(
                  context,
                  ref,
                  id: items[index]['id'],
                  testName: items[index]['name'],
                  batchName: items[index]['batchName'],
                  startTime: items[index]['startTime'],
                  endTime: items[index]['endTime'],
                  testMarks: List<Map<String, dynamic>>.from(
                    items[index]['marks'],
                  ),
                  totalMarks: items[index]['totalMarks'],
                ),
                action: PercentIndicator(
                  currentValue: countStudentsAverageMarks(
                    List<Map<String, dynamic>>.from(items[index]['marks']),
                  ),
                  totalValue: items[index]['totalMarks'],
                  description: 'On average',
                ),
                children: [
                  Text(items[index]['batchName']),
                  const SizedBox(height: 5),
                  Text(formatDateDay(items[index]['date'])),
                  Text(
                    formatTimeRange(
                      items[index]['startTime'],
                      items[index]['endTime'],
                    ),
                  ),
                ],
              )
            : const SizedBox(height: 120),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: content,
    );
  }
}
