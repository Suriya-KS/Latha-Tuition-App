import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/track_record_details.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/cards/title_input_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/label_toggle_input.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  void submitHandler(BuildContext context) {
    Navigator.pop(context);
  }

  void toggleHandler(int toggleIndex, int listIndex, WidgetRef ref) {
    final attendanceMethods = ref.read(attendanceProvider.notifier);

    if (toggleIndex == 0) {
      attendanceMethods.trackAttendance(listIndex, AttendanceStatus.present);
    }

    if (toggleIndex == 1) {
      attendanceMethods.trackAttendance(listIndex, AttendanceStatus.absent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);

    final List<AttendanceStatus> attendanceList =
        ref.watch(attendanceProvider)[Attendance.list];

    int length = dummyStudentNames.length;

    return ScrollableDetailsList(
      title: 'Track Attendance',
      onPressed: () => submitHandler(context),
      children: [
        TrackRecordDetails(
          title: trackSheetData[TrackSheet.batchName],
          date: calendarViewData[CalendarView.selectedDate],
          startTime: trackSheetData[TrackSheet.startTime],
          endTime: trackSheetData[TrackSheet.endTime],
          screen: Screen.attendance,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: length + 1,
            itemBuilder: (context, index) => index < length
                ? TitleInputCard(
                    title: dummyStudentNames[index],
                    input: LabelToggleInput(
                      iconLeft: Icons.check,
                      iconRight: Icons.close,
                      backgroundColors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.error,
                      ],
                      isSelected:
                          attendanceList[index] == AttendanceStatus.present
                              ? [true, false]
                              : [false, true],
                      onToggle: (toggleIndex) =>
                          toggleHandler(toggleIndex, index, ref),
                    ),
                  )
                : const SizedBox(height: 120),
          ),
        ),
      ],
    );
  }
}
