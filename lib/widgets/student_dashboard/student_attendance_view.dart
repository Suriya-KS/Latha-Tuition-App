import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_attendance_list.dart';

class StudentAttendanceView extends ConsumerStatefulWidget {
  const StudentAttendanceView({super.key});

  @override
  ConsumerState<StudentAttendanceView> createState() =>
      _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends ConsumerState<StudentAttendanceView> {
  final attendanceCollectionReference =
      FirebaseFirestore.instance.collection('attendance');

  bool isLoading = true;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> attendanceList = [];

  void loadAttendanceSummary(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final currentMonthStart = DateTime(currentYear, currentMonth);
    final nextMonthStart = DateTime(currentYear, currentMonth + 1);
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    try {
      final attendanceQuerySnapshot = await attendanceCollectionReference
          .where('attendance', arrayContainsAny: [
            {
              'studentID': studentID,
              'status': 'present',
            },
            {
              'studentID': studentID,
              'status': 'absent',
            },
          ])
          .where('date', isGreaterThanOrEqualTo: currentMonthStart)
          .where('date', isLessThan: nextMonthStart)
          .orderBy('date')
          .orderBy('startTime')
          .get();

      final studentAttendanceList = attendanceQuerySnapshot.docs
          .map((attendanceQueryDocumentSnapshot) => {
                'status': attendanceQueryDocumentSnapshot
                    .data()['attendance']
                    .firstWhere(
                      (attendance) => attendance['studentID'] == studentID,
                    )['status'],
                'date': attendanceQueryDocumentSnapshot.data()['date'].toDate(),
                'startTime': timestampToTimeOfDay(
                  attendanceQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  attendanceQueryDocumentSnapshot.data()['endTime'],
                ),
              })
          .toList();

      setState(() {
        attendanceList = studentAttendanceList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void monthChangeHandler(DateTime date) {
    setState(() {
      currentMonth = date.month;
      currentYear = date.year;
    });

    loadAttendanceSummary(context);
  }

  @override
  void initState() {
    super.initState();

    loadAttendanceSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Column(
        children: [
          const TextAppBar(title: 'Attendance Records'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MonthInput(onChange: monthChangeHandler),
                  const SizedBox(height: 20),
                  attendanceList.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(height: 30),
                            SvgPicture.asset(
                              notFoundImage,
                              height: 100,
                            ),
                            const SizedBox(height: 20),
                            const Text('No Records Found!'),
                          ],
                        )
                      : StudentAttendanceList(items: attendanceList),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
