import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureEducationBoards extends StatefulWidget {
  const ConfigureEducationBoards({super.key});

  @override
  State<ConfigureEducationBoards> createState() =>
      _ConfigureEducationBoardsState();
}

class _ConfigureEducationBoardsState extends State<ConfigureEducationBoards> {
  final firestore = FirebaseFirestore.instance;

  bool isChanged = false;
  List<String> educationBoards = [];

  void loadEducationBoards() async {
    final documentSnapshot =
        await firestore.collection('settings').doc('studentRegistration').get();

    setState(() {
      isChanged = false;
      educationBoards = List<String>.from(
        documentSnapshot.data()!['educationBoards'],
      );
    });
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
    await firestore
        .collection('settings')
        .doc('studentRegistration')
        .update({'educationBoards': educationBoards});

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    loadEducationBoards();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
