import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/providers/test_marks_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/tutor_student_information/tutor_student_personal_details_view.dart';
import 'package:latha_tuition_app/widgets/tutor_student_information/tutor_student_attendance_records_view.dart';
import 'package:latha_tuition_app/widgets/tutor_student_information/tutor_student_test_marks_view.dart';
import 'package:latha_tuition_app/widgets/tutor_student_information/tutor_student_payment_history_view.dart';
import 'package:latha_tuition_app/widgets/tutor_student_information/tutor_student_feedbacks_view.dart';

class TutorStudentInformationScreen extends ConsumerStatefulWidget {
  const TutorStudentInformationScreen({super.key});

  @override
  ConsumerState<TutorStudentInformationScreen> createState() =>
      _TutorStudentInformationScreenState();
}

class _TutorStudentInformationScreenState
    extends ConsumerState<TutorStudentInformationScreen> {
  static const views = [
    TutorStudentPersonalDetailsView(),
    TutorStudentAttendanceRecordsView(),
    TutorStudentTestMarksView(),
    TutorStudentPaymentHistoryView(),
    TutorStudentFeedbacksView(),
  ];

  static const screenTitles = [
    'Personal Details',
    'Attendance Records',
    'Test Marks',
    'Payment History',
    'Feedbacks'
  ];

  int index = 0;

  late String studentName;

  void studentInformationViewToggleHandler(int selectedIndex) {
    if (index == selectedIndex) return;

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

    studentName = getStudentDetails(ref)['name'];
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: TextAppBar(title: screenTitles[index]),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: screenPadding),
                child: SubtitleText(
                  subtitle: studentName,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: screenPadding),
                child: Align(
                  alignment: Alignment.center,
                  child: ToggleInput(
                    onToggle: studentInformationViewToggleHandler,
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
              views[index],
            ],
          ),
        ),
      ),
    );
  }
}
