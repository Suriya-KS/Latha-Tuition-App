import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/utilities/student_attendance_status_text.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentAttendanceList extends StatelessWidget {
  const StudentAttendanceList({
    required this.view,
    super.key,
  });

  final ViewMode view;

  @override
  Widget build(BuildContext context) {
    final items = dummyStudentAttendance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => view == ViewMode.calendar
            ? TextAvatarActionCard(
                title: items[index]['time'],
                action: items[index]['attendanceStatus'] == 'present'
                    ? StudentAttendanceStatusText(
                        'P',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )
                    : StudentAttendanceStatusText(
                        'A',
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
              )
            : TextAvatarActionCard(
                title: formatDate(items[index]['date']),
                avatarText: formatShortenDay(items[index]['date']),
                action: items[index]['attendanceStatus'] == 'present'
                    ? StudentAttendanceStatusText(
                        'P',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )
                    : StudentAttendanceStatusText(
                        'A',
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                children: [
                  Text(items[index]['time']),
                ],
              ),
      ),
    );
  }
}
