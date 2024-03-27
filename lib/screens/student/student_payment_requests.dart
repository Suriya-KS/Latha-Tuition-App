import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/year_input.dart';

class StudentPaymentRequestsScreen extends StatelessWidget {
  const StudentPaymentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TextAppBar(title: 'Payment Requests'),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: Column(
                children: [
                  YearInput(onChange: (date) {}),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyStudentPaymentHistory.length + 1,
                      itemBuilder: (context, index) => index <
                              dummyStudentPaymentHistory.length
                          ? TextAvatarActionCard(
                              title: formatDate(
                                dummyStudentPaymentHistory[index]['date'],
                              ),
                              action: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: dummyStudentPaymentHistory[index]
                                              ['status'] ==
                                          'approved'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    dummyStudentPaymentHistory[index]
                                                ['status'] ==
                                            'approved'
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              children: [
                                Text(
                                  formatAmount(
                                    dummyStudentPaymentHistory[index]['amount'],
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
