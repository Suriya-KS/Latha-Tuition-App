import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_batch_payment_history.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';

class TutorBatchSearchSheet extends ConsumerWidget {
  const TutorBatchSearchSheet({super.key});

  void changeBatchHandler(
    BuildContext context,
    WidgetRef ref, {
    String? batchName,
  }) {
    if (batchName == null) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorBatchPaymentHistoryScreen(
          batchName: batchName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorSearchData = ref.watch(tutorSearchProvider);

    return Column(
      children: [
        const TitleText(title: 'Select Batch'),
        const SizedBox(height: 30),
        Column(
          children: [
            DropdownInput(
              labelText: 'Batch Name',
              prefixIcon: Icons.groups_outlined,
              items: tutorSearchData[TutorSearch.batchNames],
              onChanged: (value) => changeBatchHandler(
                context,
                ref,
                batchName: value,
              ),
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
