import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/text_status_actions_card.dart';

class PaymentApprovalScreen extends StatefulWidget {
  const PaymentApprovalScreen({super.key});

  @override
  State<PaymentApprovalScreen> createState() => _PaymentApprovalScreenState();
}

class _PaymentApprovalScreenState extends State<PaymentApprovalScreen> {
  late List<Map<String, dynamic>> paymentDetails;

  void tapHandler(BuildContext context, int index, String status) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final paymentDetail = paymentDetails[index];
    String amount =
        formatAmount(double.tryParse(paymentDetail['amount'].toString()) ?? 0);
    Widget snackBarContent = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Payment of ₹$amount by ${paymentDetail['name']} has been ",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          TextSpan(
            text: 'rejected',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );

    if (status == 'approve') {
      snackBarContent = RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Payment of ₹$amount by ${paymentDetail['name']} has been ",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
            TextSpan(
              text: 'approved',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      );
    }

    SnackBar snackBar = SnackBar(
      content: snackBarContent,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => setState(() {
          paymentDetails.insert(index, paymentDetail);
        }),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      paymentDetails.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    paymentDetails = dummyBatchPaymentApproval;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TextAppBar(title: 'Payment Approval'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          child: ListView.builder(
            itemCount: paymentDetails.length + 1,
            itemBuilder: (context, index) => index < paymentDetails.length
                ? TextStatusActionsCard(
                    title: paymentDetails[index]['name'],
                    description: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(paymentDetails[index]['batchName']),
                        const SizedBox(height: 5),
                        Text(
                          '₹ ${formatAmount(double.tryParse(paymentDetails[index]['amount'].toString()) ?? 0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(formatDate(paymentDetails[index]['date'])),
                      ],
                    ),
                    onApproveTap: () => tapHandler(context, index, 'approve'),
                    onRejectTap: () => tapHandler(context, index, 'reject'),
                  )
                : const SizedBox(height: screenPadding),
          ),
        ),
      ),
    );
  }
}
