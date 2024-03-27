import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
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
  late List<dynamic> paymentHistoryList;

  @override
  void initState() {
    super.initState();

    paymentHistoryList = dummyBatchPaymentHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar(title: '${widget.batchName} Payment History'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Column(
          children: [
            const SizedBox(height: 5),
            MonthInput(
              onChange: (date) {},
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paymentHistoryList.length + 1,
                itemBuilder: (context, index) => index <
                        paymentHistoryList.length
                    ? TextAvatarActionCard(
                        title: paymentHistoryList[index]['name'],
                        action: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: paymentHistoryList[index]['status'] ==
                                    'approved'
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              paymentHistoryList[index]['status'] == 'approved'
                                  ? Icons.check_outlined
                                  : Icons.close_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        children: [
                          Text(
                            formatAmount(paymentHistoryList[index]['amount']),
                          ),
                          Text(
                            formatDate(paymentHistoryList[index]['date']),
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
