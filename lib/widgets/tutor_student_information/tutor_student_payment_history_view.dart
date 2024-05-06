import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/year_input.dart';

class TutorStudentPaymentHistoryView extends ConsumerStatefulWidget {
  const TutorStudentPaymentHistoryView({super.key});

  @override
  ConsumerState<TutorStudentPaymentHistoryView> createState() =>
      _TutorStudentPaymentHistoryViewState();
}

class _TutorStudentPaymentHistoryViewState
    extends ConsumerState<TutorStudentPaymentHistoryView> {
  final paymentsCollectionReference =
      FirebaseFirestore.instance.collection('payments');

  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> studentPaymentHistory = [];

  void loadStudentPaymentHistory(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];

    try {
      final currentYearStart = DateTime(currentYear);
      final nextYearStart = DateTime(currentYear + 1);

      final studentPaymentHistoryQuerySnapshot =
          await paymentsCollectionReference
              .where('studentID', isEqualTo: studentID)
              .where('date', isGreaterThanOrEqualTo: currentYearStart)
              .where('date', isLessThan: nextYearStart)
              .orderBy('date', descending: true)
              .get();

      loadingMethods.setLoadingStatus(false);

      setState(() {
        studentPaymentHistory = studentPaymentHistoryQuerySnapshot.docs
            .map((studentPaymentQueryDocumentSnapshot) => {
                  ...studentPaymentQueryDocumentSnapshot.data(),
                  'date':
                      (studentPaymentQueryDocumentSnapshot['date'] as Timestamp)
                          .toDate(),
                })
            .toList();
      });
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void yearChangeHandler(int year) {
    setState(() {
      currentYear = year;
    });

    ref.read(loadingProvider.notifier).setLoadingStatus(true);

    loadStudentPaymentHistory(context);
  }

  @override
  void initState() {
    super.initState();

    loadStudentPaymentHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Column(
          children: [
            YearInput(onChange: yearChangeHandler),
            const SizedBox(height: 10),
            studentPaymentHistory.isEmpty
                ? ImageWithCaption(
                    imagePath: Theme.of(context).brightness == Brightness.light
                        ? notFoundImage
                        : notFoundImageDark,
                    description: 'No payments found!',
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: studentPaymentHistory.length + 1,
                      itemBuilder: (context, index) => index <
                              studentPaymentHistory.length
                          ? TextAvatarActionCard(
                              title: formatDate(
                                studentPaymentHistory[index]['date'],
                              ),
                              action: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: getPaymentContainerColor(
                                    context,
                                    studentPaymentHistory[index]['status'],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    getPaymentStatusIcon(
                                      studentPaymentHistory[index]['status'],
                                    ),
                                    color: studentPaymentHistory[index]
                                                ['status'] ==
                                            'pending approval'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .background,
                                  ),
                                ),
                              ),
                              children: [
                                Text(
                                  formatAmount(
                                    studentPaymentHistory[index]['amount'],
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            )
                          : const SizedBox(height: screenPadding),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
