import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/utilities/avatar_text.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class TutorStudentAttendanceRecordsView extends ConsumerStatefulWidget {
  const TutorStudentAttendanceRecordsView({super.key});

  @override
  ConsumerState<TutorStudentAttendanceRecordsView> createState() =>
      _TutorStudentAttendanceRecordsViewState();
}

class _TutorStudentAttendanceRecordsViewState
    extends ConsumerState<TutorStudentAttendanceRecordsView> {
  final attendanceCollectionReference =
      FirebaseFirestore.instance.collection('attendance');

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> attendanceList = [];

  void loadAttendanceSummary(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);
    final currentMonthStart = DateTime(currentYear, currentMonth);
    final nextMonthStart = DateTime(currentYear, currentMonth + 1);
    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];

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
      });

      loadingMethods.setLoadingStatus(false);
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

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

    ref.read(loadingProvider.notifier).setLoadingStatus(true);

    loadAttendanceSummary(context);
  }

  @override
  void initState() {
    super.initState();

    loadAttendanceSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Column(
          children: [
            MonthInput(onChange: monthChangeHandler),
            const SizedBox(height: 10),
            attendanceList.isEmpty
                ? ImageWithCaption(
                    imagePath: Theme.of(context).brightness == Brightness.light
                        ? notFoundImage
                        : notFoundImageDark,
                    description: 'No records found!',
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: attendanceList.length + 1,
                      itemBuilder: (context, index) => index <
                              attendanceList.length
                          ? TextAvatarActionCard(
                              title: formatDate(attendanceList[index]['date']),
                              action: attendanceList[index]['status'] ==
                                      'present'
                                  ? AvatarText(
                                      'P',
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : AvatarText(
                                      'A',
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              children: [
                                Text(
                                  formatTimeRange(
                                    attendanceList[index]['startTime'],
                                    attendanceList[index]['endTime'],
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            )
                          : const SizedBox(height: 120),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
