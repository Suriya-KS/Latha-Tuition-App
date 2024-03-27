import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/tutor_track_record_details.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';

class TutorTrackAttendanceScreen extends ConsumerWidget {
  const TutorTrackAttendanceScreen({
    required this.screen,
    super.key,
  });

  final Screen screen;

  void trackAttendanceHandler(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);

    final List<dynamic> attendanceList = ref.watch(attendanceProvider);

    return ScrollableDetailsList(
      title: 'Track Attendance',
      onPressed: () => trackAttendanceHandler(context),
      children: [
        TutorTrackRecordDetails(
          title: trackSheetData[TrackSheet.batchName],
          date: calendarViewData[CalendarView.selectedDate],
          startTime: trackSheetData[TrackSheet.startTime],
          endTime: trackSheetData[TrackSheet.endTime],
          screen: Screen.attendance,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: attendanceList.length + 1,
            itemBuilder: (context, index) => index < attendanceList.length
                ? TextAvatarActionCard(
                    title: attendanceList[index]['name'],
                    action: ToggleInput(
                      backgroundColors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.error,
                      ],
                      isSelected:
                          attendanceList[index]['attendanceStatus'] == 'present'
                              ? [true, false]
                              : [false, true],
                      onToggle: (toggleIndex) => attendanceStatusToggleHandler(
                        toggleIndex,
                        index,
                        ref,
                      ),
                      children: const [
                        Icon(Icons.check),
                        Icon(Icons.close),
                      ],
                    ),
                  )
                : const SizedBox(height: 120),
          ),
        ),
      ],
    );
  }
}
