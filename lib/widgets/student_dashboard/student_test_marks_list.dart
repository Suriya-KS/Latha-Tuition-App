import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/utilities/student_test_marks_text.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentTestMarksList extends StatelessWidget {
  const StudentTestMarksList({
    required this.view,
    super.key,
  });

  final ViewMode view;

  @override
  Widget build(BuildContext context) {
    final items = dummyStudentTestMarks;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => view == ViewMode.calendar
            ? TextAvatarActionCard(
                title: items[index]['name'],
                action: StudentTestMarksText(
                  marks: items[index]['marks'],
                  totalMarks: items[index]['totalMarks'],
                ),
                children: [
                  Text(items[index]['time']),
                ],
              )
            : TextAvatarActionCard(
                title: items[index]['name'],
                action: StudentTestMarksText(
                  marks: items[index]['marks'],
                  totalMarks: items[index]['totalMarks'],
                ),
                children: [
                  Text(formatDateDay(items[index]['date'])),
                  Text(items[index]['time']),
                ],
              ),
      ),
    );
  }
}
