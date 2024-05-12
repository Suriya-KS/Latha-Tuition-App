import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/alert_dialogue.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class TutorConfigureEducationBoards extends StatefulWidget {
  const TutorConfigureEducationBoards({super.key});

  @override
  State<TutorConfigureEducationBoards> createState() =>
      _TutorConfigureEducationBoardsState();
}

class _TutorConfigureEducationBoardsState
    extends State<TutorConfigureEducationBoards> {
  final settingsDocumentReference = FirebaseFirestore.instance
      .collection('settings')
      .doc('studentRegistration');

  bool isLoading = true;
  bool isChanged = false;
  List<String> educationBoards = [];

  void loadEducationBoards(BuildContext context) async {
    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      setState(() {
        isLoading = false;
      });

      if (!settingsDocumentSnapshot.exists ||
          !settingsDocumentSnapshot.data()!.containsKey('educationBoards')) {
        return;
      }

      setState(() {
        isLoading = false;
        isChanged = false;
        educationBoards = List<String>.from(
          settingsDocumentSnapshot.data()!['educationBoards'],
        );
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void addEducationBoardHandler(String educationBoard) {
    setState(() {
      isChanged = true;
      educationBoards.add(educationBoard);
    });

    Navigator.pop(context);
  }

  void editEducationBoardHandler(int index, String educationBoard) {
    setState(() {
      isChanged = true;
      educationBoards[index] = educationBoard;
    });

    Navigator.pop(context);
  }

  void deleteEducationBoardHandler(int index) {
    final educationBoard = educationBoards[index];

    snackBar(
      context,
      content: Text('Education board "$educationBoard" has been deleted'),
      actionLabel: 'Undo',
      onPressed: () => setState(() {
        educationBoards.insert(index, educationBoard);
      }),
    );

    setState(() {
      isChanged = true;
      educationBoards.removeAt(index);
    });
  }

  void saveEducationBoardHandler(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      if (settingsDocumentSnapshot.exists) {
        await settingsDocumentReference.update(
          {'educationBoards': educationBoards},
        );
      } else {
        await settingsDocumentReference.set(
          {'educationBoards': educationBoards},
        );
      }

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    loadEducationBoards(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isChanged,
      onPopInvoked: (didPop) => !didPop
          ? alertDialogue(
              context,
              actions: [
                TextButton(
                  onPressed: () => closeAlertDialogue(
                    context,
                    function: Navigator.pop,
                  ),
                  child: const Text('Discard'),
                ),
                OutlinedButton(
                  onPressed: () => closeAlertDialogue(
                    context,
                    function: saveEducationBoardHandler,
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          : null,
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: const TextAppBar(
            title: 'Configure Education Boards',
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
                        editEducationBoardHandler(index, educationBoard),
                    onIconPressAndSwipe: (index) =>
                        deleteEducationBoardHandler(index),
                    onButtonPress: (educationBoard) =>
                        addEducationBoardHandler(educationBoard),
                  ),
                ),
                const SizedBox(height: 20),
                if (isChanged)
                  PrimaryButton(
                    title: 'Save',
                    onPressed: () => saveEducationBoardHandler(context),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
