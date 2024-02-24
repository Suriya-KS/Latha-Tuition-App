import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/student_administration_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureBatchesScreen extends ConsumerWidget {
  const ConfigureBatchesScreen({super.key});

  void addHandler(BuildContext context, WidgetRef ref, String batchName) {
    Navigator.pop(context);

    ref.read(studentAdministrationProvider.notifier).addBatch(batchName);
  }

  void editHandler(
    BuildContext context,
    WidgetRef ref,
    int index,
    String batchName,
  ) {
    Navigator.pop(context);

    ref
        .read(studentAdministrationProvider.notifier)
        .updateBatch(batchName, index);
  }

  void deleteHandler(BuildContext context, WidgetRef ref, int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final batchName =
        ref.read(studentAdministrationProvider)[StudentAdministration.batches]
            [index];

    SnackBar snackBar = SnackBar(
      content: Text('Batch "$batchName" has been deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          ref.read(studentAdministrationProvider.notifier).addBatch(
                batchName,
                index: index,
              );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    ref.read(studentAdministrationProvider.notifier).deleteBatch(index);
  }

  void submitHandler(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches =
        ref.watch(studentAdministrationProvider)[StudentAdministration.batches];

    return Scaffold(
      appBar: const TextAppBar(
        title: 'Manage Batches',
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TitleIconList(
                fieldName: 'batch name',
                items: batches,
                onListTileTap: (index, batchName) =>
                    editHandler(context, ref, index, batchName),
                onIconPressAndSwipe: (index) =>
                    deleteHandler(context, ref, index),
                onButtonPress: (batchName) =>
                    addHandler(context, ref, batchName),
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
