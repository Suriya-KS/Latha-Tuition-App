import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/student_administration_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureEducationBoards extends ConsumerWidget {
  const ConfigureEducationBoards({super.key});

  void addHandler(BuildContext context, WidgetRef ref, String educationBoard) {
    Navigator.pop(context);

    ref
        .read(studentAdministrationProvider.notifier)
        .addEducationBoard(educationBoard);
  }

  void editHandler(
    BuildContext context,
    WidgetRef ref,
    int index,
    String educationBoard,
  ) {
    Navigator.pop(context);

    ref
        .read(studentAdministrationProvider.notifier)
        .updateEducationBoard(educationBoard, index);
  }

  void deleteHandler(BuildContext context, WidgetRef ref, int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final educationBoard = ref.read(studentAdministrationProvider)[
        StudentAdministration.educationBoards][index];

    SnackBar snackBar = SnackBar(
      content: Text('Education board "$educationBoard" has been deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          ref.read(studentAdministrationProvider.notifier).addEducationBoard(
                educationBoard,
                index: index,
              );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    ref
        .read(studentAdministrationProvider.notifier)
        .deleteEducationBoard(index);
  }

  void submitHandler(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educationBoards = ref.watch(
        studentAdministrationProvider)[StudentAdministration.educationBoards];

    return Scaffold(
      appBar: const TextAppBar(
        title: 'Manage Education Boards',
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TitleIconList(
                fieldName: 'education board',
                items: educationBoards,
                onListTileTap: (index, educationBoard) =>
                    editHandler(context, ref, index, educationBoard),
                onIconPressAndSwipe: (index) =>
                    deleteHandler(context, ref, index),
                onButtonPress: (educationBoard) =>
                    addHandler(context, ref, educationBoard),
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
