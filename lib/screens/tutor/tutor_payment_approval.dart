import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class TutorPaymentApprovalScreen extends StatefulWidget {
  const TutorPaymentApprovalScreen({super.key});

  @override
  State<TutorPaymentApprovalScreen> createState() =>
      _TutorPaymentApprovalScreenState();
}

class _TutorPaymentApprovalScreenState
    extends State<TutorPaymentApprovalScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool isProcessing = false;
  List<Map<String, dynamic>> studentsPaymentDetails = [];

  void loadStudentsPaymentRequests(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final studentPaymentRequestsQuerySnapshot = await firestore
          .collection('payments')
          .where('status', isEqualTo: 'pending approval')
          .orderBy('date')
          .get();

      List<Map<String, dynamic>> paymentDetails = [];

      for (final studentPaymentRequestQueryDocumentSnapshot
          in studentPaymentRequestsQuerySnapshot.docs) {
        if (!studentPaymentRequestQueryDocumentSnapshot.exists) continue;

        final studentDocumentSnapshot = await firestore
            .collection('students')
            .doc(studentPaymentRequestQueryDocumentSnapshot['studentID'])
            .get();

        if (!studentDocumentSnapshot.exists) continue;

        final studentDetails = studentDocumentSnapshot.data()!;
        final studentPaymentDetails =
            studentPaymentRequestQueryDocumentSnapshot.data();

        paymentDetails.add({
          'studentName': studentDetails['name'],
          'batch': studentDetails['batch'],
          'date': (studentPaymentDetails['date'] as Timestamp).toDate(),
          'amount': studentPaymentDetails['amount'],
          'id': studentPaymentRequestQueryDocumentSnapshot.id,
        });
      }

      setState(() {
        isLoading = false;
        studentsPaymentDetails = paymentDetails;
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

  void statusTapHandler(
    BuildContext context, {
    required int index,
    required bool isApproved,
  }) async {
    setState(() {
      isProcessing = true;
    });

    final studentPaymentDetails = {...studentsPaymentDetails[index]};
    final amount = formatAmount(studentPaymentDetails['amount']);
    final snackBarContent = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                "Payment of $amount by ${studentPaymentDetails['studentName']} has been ",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.background),
          ),
          TextSpan(
            text: isApproved ? 'approved' : 'rejected',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );

    setState(() {
      studentsPaymentDetails.removeAt(index);
    });

    try {
      await snackBar(
        context,
        content: snackBarContent,
        actionLabel: 'Undo',
        onPressed: () => setState(() {
          studentsPaymentDetails.insert(index, studentPaymentDetails);
        }),
      );

      if (studentsPaymentDetails.contains(studentPaymentDetails)) {
        setState(() {
          isProcessing = false;
        });

        return;
      }

      setState(() {
        isLoading = true;
      });

      await firestore
          .collection('payments')
          .doc(studentPaymentDetails['id'])
          .update({
        'status': isApproved ? 'approved' : 'rejected',
        'notifyStudent': true,
      });

      setState(() {
        isLoading = false;
        isProcessing = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isProcessing = false;
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

    loadStudentsPaymentRequests(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isProcessing,
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: const TextAppBar(title: 'Payment Approval'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: studentsPaymentDetails.isEmpty
                  ? ImageWithCaption(
                      imagePath:
                          Theme.of(context).brightness == Brightness.light
                              ? notFoundImage
                              : notFoundImageDark,
                      description: 'No requests found!',
                    )
                  : ListView.builder(
                      itemCount: studentsPaymentDetails.length + 1,
                      itemBuilder: (context, index) => index <
                              studentsPaymentDetails.length
                          ? TextAvatarActionCard(
                              title: studentsPaymentDetails[index]
                                  ['studentName'],
                              action: Column(
                                children: [
                                  IconButton(
                                    onPressed: !isProcessing
                                        ? () => statusTapHandler(
                                              context,
                                              index: index,
                                              isApproved: true,
                                            )
                                        : null,
                                    icon: const Icon(Icons.check_outlined),
                                    style: IconButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: !isProcessing
                                        ? () => statusTapHandler(
                                              context,
                                              index: index,
                                              isApproved: false,
                                            )
                                        : null,
                                    icon: const Icon(Icons.close_outlined),
                                    style: IconButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Text(studentsPaymentDetails[index]['batch']),
                                const SizedBox(height: 5),
                                Text(
                                  formatAmount(
                                      studentsPaymentDetails[index]['amount']),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formatDate(
                                    studentsPaymentDetails[index]['date'],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(height: screenPadding),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
