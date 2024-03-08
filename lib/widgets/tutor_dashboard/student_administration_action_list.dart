import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/screens/student_approval.dart';
import 'package:latha_tuition_app/screens/payment_approval.dart';
import 'package:latha_tuition_app/widgets/cards/box_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/student_search_sheet.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/batch_search_sheet.dart';

class StudentAdministrationActionList extends StatelessWidget {
  const StudentAdministrationActionList({super.key});

  void studentSearchTapHandler(BuildContext context) {
    modalBottomSheet(
      context,
      const StudentSearchSheet(),
    );
  }

  void batchPaymentHistoryTapHandler(BuildContext context) {
    modalBottomSheet(
      context,
      const BatchSearchSheet(),
    );
  }

  void studentApprovalTapHandler(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentApprovalScreen(),
      ),
    );
  }

  void paymentApprovalTapHandler(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentApprovalScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxCard(
                    title: 'Student Search',
                    image: searchImage,
                    onTap: () => studentSearchTapHandler(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BoxCard(
                    title: 'Batch wise Payments',
                    image: groupPaymentImage,
                    onTap: () => batchPaymentHistoryTapHandler(context),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxCard(
                    title: 'Student Approval',
                    image: pendingApprovalImage,
                    onTap: () => studentApprovalTapHandler(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BoxCard(
                    title: 'Payment Approval',
                    image: phoneConfirmImage,
                    onTap: () => paymentApprovalTapHandler(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
