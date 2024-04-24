import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_test_marks_list.dart';

class StudentTestMarksView extends ConsumerStatefulWidget {
  const StudentTestMarksView({super.key});

  @override
  ConsumerState<StudentTestMarksView> createState() => _StudentTestViewState();
}

class _StudentTestViewState extends ConsumerState<StudentTestMarksView> {
  final testMarksCollectionReference =
      FirebaseFirestore.instance.collection('testMarks');

  bool isLoading = true;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> testMarks = [];

  void loadTestMarksSummary(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final currentMonthStart = DateTime(currentYear, currentMonth);
    final nextMonthStart = DateTime(currentYear, currentMonth + 1);
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    try {
      final testMarksQuerySnapshot = await testMarksCollectionReference
          .where('date', isGreaterThanOrEqualTo: currentMonthStart)
          .where('date', isLessThan: nextMonthStart)
          .orderBy('date')
          .orderBy('startTime')
          .get();

      final documentIDs = [];

      for (final testMarksQueryDocumentSnapshot
          in testMarksQuerySnapshot.docs) {
        final studentTestMark = testMarksQueryDocumentSnapshot
            .data()['marks']
            .where(
              (marks) => marks['studentID'] == studentID,
            )
            .toList();

        if (studentTestMark.length == 0) continue;

        documentIDs.add(testMarksQueryDocumentSnapshot.id);
      }

      final studentTestMarksQueryDocumentSnapshots = testMarksQuerySnapshot.docs
          .where((testMarksQueryDocumentSnapshot) => documentIDs.contains(
                testMarksQueryDocumentSnapshot.id,
              ))
          .toList();

      final studentTestMarks = studentTestMarksQueryDocumentSnapshots
          .map((testMarksQueryDocumentSnapshot) => {
                'name': testMarksQueryDocumentSnapshot.data()['name'],
                'date': testMarksQueryDocumentSnapshot.data()['date'].toDate(),
                'startTime': timestampToTimeOfDay(
                  testMarksQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  testMarksQueryDocumentSnapshot.data()['endTime'],
                ),
                'marks':
                    testMarksQueryDocumentSnapshot.data()['marks'].firstWhere(
                          (marks) => marks['studentID'] == studentID,
                        )['marks'],
                'totalMarks':
                    testMarksQueryDocumentSnapshot.data()['totalMarks'],
              })
          .toList();

      setState(() {
        testMarks = studentTestMarks;
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

    loadTestMarksSummary(context);
  }

  @override
  void initState() {
    super.initState();

    loadTestMarksSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Column(
        children: [
          const TextAppBar(title: 'Test Marks Records'),
          MonthInput(onChange: monthChangeHandler),
          testMarks.isEmpty
              ? const ImageWithCaption(
                  imagePath: notFoundImage,
                  description: 'No records found!',
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        testMarks.isEmpty
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
                            : StudentTestMarksList(items: testMarks),
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
