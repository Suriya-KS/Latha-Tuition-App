import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/utilities/percent_indicator.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class TutorStudentTestMarksView extends ConsumerStatefulWidget {
  const TutorStudentTestMarksView({super.key});

  @override
  ConsumerState<TutorStudentTestMarksView> createState() =>
      _TutorStudentTestMarksViewState();
}

class _TutorStudentTestMarksViewState
    extends ConsumerState<TutorStudentTestMarksView> {
  final testMarksCollectionReference =
      FirebaseFirestore.instance.collection('testMarks');

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> testMarks = [];

  void loadTestMarksSummary(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);
    final currentMonthStart = DateTime(currentYear, currentMonth);
    final nextMonthStart = DateTime(currentYear, currentMonth + 1);
    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];

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

    loadTestMarksSummary(context);
  }

  @override
  void initState() {
    super.initState();

    loadTestMarksSummary(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Stack(
          children: [
            Column(
              children: [
                MonthInput(onChange: monthChangeHandler),
                const SizedBox(height: 10),
                testMarks.isEmpty
                    ? ImageWithCaption(
                        imagePath:
                            Theme.of(context).brightness == Brightness.light
                                ? notFoundImage
                                : notFoundImageDark,
                        description: 'No records found!',
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: testMarks.length + 1,
                          itemBuilder: (context, index) => index <
                                  testMarks.length
                              ? TextAvatarActionCard(
                                  title: testMarks[index]['name'].toString(),
                                  action: SizedBox(
                                      width: 120,
                                      child: PercentIndicator(
                                        currentValue: testMarks[index]['marks'],
                                        totalValue: testMarks[index]
                                            ['totalMarks'],
                                        showPercentage: false,
                                        description:
                                            'Out of ${formatMarks(testMarks[index]['totalMarks'])}',
                                      )),
                                  children: [
                                    Text(formatDate(testMarks[index]['date'])),
                                    Text(
                                      formatTimeRange(
                                        testMarks[index]['startTime'],
                                        testMarks[index]['endTime'],
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
          ],
        ),
      ),
    );
  }
}
