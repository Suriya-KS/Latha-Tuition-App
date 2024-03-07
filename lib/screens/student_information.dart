import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/providers/test_marks_provider.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/personal_details_view.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/attendance_records_view.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/test_marks_view.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/payment_history_view.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/feedbacks_view.dart';

class StudentInformationScreen extends ConsumerStatefulWidget {
  const StudentInformationScreen({super.key});

  @override
  ConsumerState<StudentInformationScreen> createState() =>
      _StudentInformationScreenState();
}

class _StudentInformationScreenState
    extends ConsumerState<StudentInformationScreen> {
  static const pages = [
    PersonalDetailsView(),
    AttendanceRecordsView(),
    TestMarksView(),
    PaymentHistoryView(),
    FeedbacksView(),
  ];

  late int index;

  void toggleHandler(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });

    if (selectedIndex == 1) {
      ref
          .read(attendanceProvider.notifier)
          .setInitialState(dummyStudentAttendance);
    } else if (selectedIndex == 2) {
      ref
          .read(testMarksProvider.notifier)
          .setInitialState(dummyStudentTestMarks);
    }
  }

  @override
  void initState() {
    super.initState();

    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar(title: studentInformationScreenTitles[index]),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: SubtitleText(
                subtitle: 'Student Name',
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: Align(
                alignment: Alignment.center,
                child: ToggleInput(
                  onToggle: toggleHandler,
                  children: const [
                    Icon(Icons.person_outline),
                    Icon(Icons.groups_outlined),
                    Icon(Icons.assignment_outlined),
                    Icon(Icons.currency_rupee_outlined),
                    Icon(Icons.message_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            pages[index],
          ],
        ),
      ),
    );
  }
}
