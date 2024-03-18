import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/screens/batch_payment_history.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';

class BatchSearchSheet extends StatelessWidget {
  const BatchSearchSheet({super.key});

  void changeBatchHandler(BuildContext context, String? batchName) {
    if (batchName == null) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchPaymentHistoryScreen(batchName: batchName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(title: 'Select Batch'),
        const SizedBox(height: 30),
        Column(
          children: [
            DropdownInput(
              labelText: 'Batch Name',
              prefixIcon: Icons.groups_outlined,
              items: dummyBatchNames,
              onChanged: (value) => changeBatchHandler(context, value),
              validator: (value) =>
                  validateRequiredInput(value, 'a', 'batch name'),
            ),
            const SizedBox(height: screenPadding),
          ],
        ),
      ],
    );
  }
}
