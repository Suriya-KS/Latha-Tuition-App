import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/student_administration_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureEducationBoards extends ConsumerWidget {
  const ConfigureEducationBoards({super.key});

  void addEducationBoardHandler(
      BuildContext context, WidgetRef ref, String educationBoard) {
    Navigator.pop(context);

    ref
        .read(studentAdministrationProvider.notifier)
        .addEducationBoard(educationBoard);
  }

  void editEducationBoardHandler(
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

  void deleteEducationBoardHandler(
      BuildContext context, WidgetRef ref, int index) {
    final educationBoard = ref.read(studentAdministrationProvider)[
        StudentAdministration.educationBoards][index];

    snackBar(
      context,
      content: Text('Education board "$educationBoard" has been deleted'),
      actionLabel: 'Undo',
      onPressed: () =>
          ref.read(studentAdministrationProvider.notifier).addEducationBoard(
                educationBoard,
                index: index,
              ),
    );

    ref
        .read(studentAdministrationProvider.notifier)
        .deleteEducationBoard(index);
  }

  void saveEducationBoardHandler(BuildContext context) {
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
                    editEducationBoardHandler(
                        context, ref, index, educationBoard),
                onIconPressAndSwipe: (index) =>
                    deleteEducationBoardHandler(context, ref, index),
                onButtonPress: (educationBoard) =>
                    addEducationBoardHandler(context, ref, educationBoard),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: 'Save',
              onPressed: () => saveEducationBoardHandler(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
