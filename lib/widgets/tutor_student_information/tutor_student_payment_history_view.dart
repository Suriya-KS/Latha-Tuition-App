import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/cards/text_status_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/year_input.dart';

class TutorStudentPaymentHistoryView extends StatefulWidget {
  const TutorStudentPaymentHistoryView({super.key});

  @override
  State<TutorStudentPaymentHistoryView> createState() =>
      _TutorStudentPaymentHistoryViewState();
}

class _TutorStudentPaymentHistoryViewState
    extends State<TutorStudentPaymentHistoryView> {
  late List<dynamic> paymentHistoryList;

  @override
  void initState() {
    super.initState();

    paymentHistoryList = dummyStudentPaymentHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Column(
          children: [
            YearInput(
              onChange: (date) {},
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paymentHistoryList.length + 1,
                itemBuilder: (context, index) => index <
                        paymentHistoryList.length
                    ? TextStatusCard(
                        title: formatDate(paymentHistoryList[index]['date']),
                        description: Text(
                          '₹ ${formatAmount(double.tryParse(paymentHistoryList[index]['amount'].toString()) ?? 0)}',
                        ),
                        status: paymentHistoryList[index]['status'],
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
