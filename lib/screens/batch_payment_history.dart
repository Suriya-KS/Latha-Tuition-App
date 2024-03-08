import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/text_status_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class BatchPaymentHistoryScreen extends StatefulWidget {
  const BatchPaymentHistoryScreen({
    required this.batchName,
    super.key,
  });

  final String batchName;

  @override
  State<BatchPaymentHistoryScreen> createState() =>
      _BatchPaymentHistoryScreenState();
}

class _BatchPaymentHistoryScreenState extends State<BatchPaymentHistoryScreen> {
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
      body: Expanded(
        child: Padding(
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
                      ? TextStatusCard(
                          title: paymentHistoryList[index]['name'],
                          description: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                '₹ ${formatAmount(double.tryParse(paymentHistoryList[index]['amount'].toString()) ?? 0)}',
                              ),
                              Text(
                                formatDate(paymentHistoryList[index]['date']),
                              ),
                            ],
                          ),
                          status: paymentHistoryList[index]['status'],
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
