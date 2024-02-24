import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/student_administration_provider.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureStandardsScreen extends ConsumerWidget {
  const ConfigureStandardsScreen({super.key});

  void submitHandler(BuildContext context) {
    Navigator.pop(context);
  }

  void changeHandler(WidgetRef ref, String standard, bool isChecked) {
    ref
        .read(studentAdministrationProvider.notifier)
        .updateEnabledStandards(standard, isChecked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAdministrationData = ref.watch(studentAdministrationProvider);
    final List<dynamic> standards =
        studentAdministrationData[StudentAdministration.standards];
    final List<dynamic> enabledStandards =
        studentAdministrationData[StudentAdministration.enabledStandards];

    return Scaffold(
      appBar: const TextAppBar(title: 'Manage Standards'),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (String standard in standards)
                      SwitchListTile(
                        title: Text(standard),
                        value: enabledStandards.contains(standard),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        onChanged: (isChecked) =>
                            changeHandler(ref, standard, isChecked),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: 'Save',
              onPressed: () => submitHandler(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
