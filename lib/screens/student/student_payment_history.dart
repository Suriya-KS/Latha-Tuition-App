import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/student_payment_request_sheet.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/year_input.dart';

class StudentPaymentHistoryScreen extends ConsumerStatefulWidget {
  const StudentPaymentHistoryScreen({super.key});

  @override
  ConsumerState<StudentPaymentHistoryScreen> createState() =>
      _StudentPaymentRequestsScreenState();
}

class _StudentPaymentRequestsScreenState
    extends ConsumerState<StudentPaymentHistoryScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> studentPaymentHistory = [];

  Future<void> updateNotifyStudentToFalse(String studentID) async {
    final paymentHistoryQuerySnapshot = await firestore
        .collection('payments')
        .where('studentID', isEqualTo: studentID)
        .where('notifyStudent', isEqualTo: true)
        .get();

    final batch = firestore.batch();

    for (final paymentHistoryQueryDocumentSnapshot
        in paymentHistoryQuerySnapshot.docs) {
      batch.update(
        paymentHistoryQueryDocumentSnapshot.reference,
        {'notifyStudent': false},
      );
    }

    await batch.commit();
  }

  void loadPaymentHistory(BuildContext context) async {
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    setState(() {
      isLoading = true;
    });

    try {
      await updateNotifyStudentToFalse(studentID);

      final currentYearStart = DateTime(currentYear);
      final nextYearStart = DateTime(currentYear + 1);

      final studentPaymentHistoryQuerySnapshot = await firestore
          .collection('payments')
          .where('studentID', isEqualTo: studentID)
          .where('date', isGreaterThanOrEqualTo: currentYearStart)
          .where('date', isLessThan: nextYearStart)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        isLoading = false;
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

  void yearChangeHandler(int year) {
    currentYear = year;

    loadPaymentHistory(context);
  }

  void fetchFeesAmountAndShowPaymentRequestSheet(BuildContext context) async {
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    setState(() {
      isLoading = true;
    });

    try {
      final studentDocumentSnapshot =
          await firestore.collection('students').doc(studentID).get();

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      final didPaymentHistoryChange = await modalBottomSheet(
            context,
            StudentPaymentRequestSheet(
              feesAmount: studentDocumentSnapshot['feesAmount'],
            ),
          ) ??
          false;

      if (!didPaymentHistoryChange) return;
      if (!context.mounted) return;

      loadPaymentHistory(context);
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

  @override
  void initState() {
    super.initState();

    loadPaymentHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const TextAppBar(title: 'Payment History'),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
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
                                title: formatDate(
                                  studentPaymentHistory[index]['date'],
                                ),
                                action: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: getPaymentContainerColor(
                                      context,
                                      studentPaymentHistory[index]['status'],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      getPaymentStatusIcon(
                                        studentPaymentHistory[index]['status'],
                                      ),
                                      color: studentPaymentHistory[index]
                                                  ['status'] ==
                                              'pending approval'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.white,
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
                            : const SizedBox(height: 120),
                      ),
                    ),
                    const SizedBox(height: screenPadding),
                  ],
                ),
              ),
              FloatingCircularActionButton(
                icon: Icons.add_outlined,
                onPressed: () => fetchFeesAmountAndShowPaymentRequestSheet(
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
