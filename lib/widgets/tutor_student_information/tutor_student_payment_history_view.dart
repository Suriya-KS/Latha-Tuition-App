import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/student_search_provider.dart';
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
  List<dynamic> studentPaymentHistory = [];

  void loadStudentPaymentHistory(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    final studentID =
        ref.read(studentSearchProvider)[StudentSearch.selectedStudentID];

    try {
      final currentYearStart = DateTime(currentYear, 1, 1);
      final nextYearStart = DateTime(currentYear + 1, 1, 1);

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
            .map((studentPayment) => {
                  ...studentPayment.data(),
                  'date': (studentPayment['date'] as Timestamp).toDate(),
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
            Expanded(
              child: ListView.builder(
                itemCount: studentPaymentHistory.length + 1,
                itemBuilder: (context, index) => index <
                        studentPaymentHistory.length
                    ? TextAvatarActionCard(
                        title: formatDate(studentPaymentHistory[index]['date']),
                        action: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: studentPaymentHistory[index]['status'] ==
                                    'approved'
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              studentPaymentHistory[index]['status'] ==
                                      'approved'
                                  ? Icons.check_outlined
                                  : Icons.close_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        children: [
                          Text(
                            formatAmount(
                              studentPaymentHistory[index]['amount'],
                            ),
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
