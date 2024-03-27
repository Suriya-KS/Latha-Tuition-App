import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
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
                    ? TextAvatarActionCard(
                        title: formatDate(paymentHistoryList[index]['date']),
                        action: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
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
