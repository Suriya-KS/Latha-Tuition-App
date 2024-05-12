import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class TutorBatchPaymentHistoryScreen extends StatefulWidget {
  const TutorBatchPaymentHistoryScreen({
    required this.batchName,
    super.key,
  });

  final String batchName;

  @override
  State<TutorBatchPaymentHistoryScreen> createState() =>
      _TutorBatchPaymentHistoryScreenState();
}

class _TutorBatchPaymentHistoryScreenState
    extends State<TutorBatchPaymentHistoryScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  List<Map<String, dynamic>> paymentHistory = [];

  void loadBatchPaymentHistory(BuildContext context) async {
    final currentMonthStart = DateTime(currentYear, currentMonth);
    final nextMonthStart = DateTime(currentYear, currentMonth + 1);

    try {
      final paymentRequestsQuerySnapshot = await firestore
          .collection('payments')
          .where('date', isGreaterThanOrEqualTo: currentMonthStart)
          .where('date', isLessThan: nextMonthStart)
          .orderBy('date')
          .get();

      List<Map<String, dynamic>> paymentDetails = [];

      for (final paymentRequestQueryDocumentSnapshot
          in paymentRequestsQuerySnapshot.docs) {
        if (!paymentRequestQueryDocumentSnapshot.exists) continue;

        final studentDocumentSnapshot = await firestore
            .collection('students')
            .doc(paymentRequestQueryDocumentSnapshot['studentID'])
            .get();

        if (!studentDocumentSnapshot.exists) continue;

        final studentDetails = studentDocumentSnapshot.data()!;
        final studentPaymentDetails =
            paymentRequestQueryDocumentSnapshot.data();

        if (studentDetails['batch'] != widget.batchName) continue;
        if (studentPaymentDetails['status'] == 'pending approval') continue;

        paymentDetails.add({
          'studentName': studentDetails['name'],
          'date': (studentPaymentDetails['date'] as Timestamp).toDate(),
          'amount': studentPaymentDetails['amount'],
          'status': studentPaymentDetails['status'],
        });
      }

      setState(() {
        isLoading = false;
        paymentHistory = paymentDetails;
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
      isLoading = true;
    });

    currentMonth = date.month;
    currentYear = date.year;

    loadBatchPaymentHistory(context);
  }

  @override
  void initState() {
    super.initState();

    loadBatchPaymentHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: TextAppBar(title: '${widget.batchName} Payment History'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          child: Column(
            children: [
              const SizedBox(height: 5),
              MonthInput(onChange: monthChangeHandler),
              const SizedBox(height: 10),
              paymentHistory.isEmpty
                  ? Expanded(
                      child: ImageWithCaption(
                        imagePath:
                            Theme.of(context).brightness == Brightness.light
                                ? notFoundImage
                                : notFoundImageDark,
                        description: 'No payments found!',
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: paymentHistory.length + 1,
                        itemBuilder: (context, index) => index <
                                paymentHistory.length
                            ? TextAvatarActionCard(
                                title: paymentHistory[index]['studentName'],
                                action: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: paymentHistory[index]['status'] ==
                                            'approved'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.error,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      paymentHistory[index]['status'] ==
                                              'approved'
                                          ? Icons.check_outlined
                                          : Icons.close_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                ),
                                children: [
                                  Text(
                                    formatAmount(
                                        paymentHistory[index]['amount']),
                                  ),
                                  Text(
                                    formatDate(paymentHistory[index]['date']),
                                  ),
                                ],
                              )
                            : const SizedBox(height: screenPadding),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
