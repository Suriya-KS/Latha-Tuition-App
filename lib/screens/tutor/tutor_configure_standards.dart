import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

const standards = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X',
  'XI',
  'XII',
];

class TutorConfigureStandardsScreen extends StatefulWidget {
  const TutorConfigureStandardsScreen({super.key});

  @override
  State<TutorConfigureStandardsScreen> createState() =>
      _TutorConfigureStandardsScreenState();
}

class _TutorConfigureStandardsScreenState
    extends State<TutorConfigureStandardsScreen> {
  final settingsDocumentReference = FirebaseFirestore.instance
      .collection('settings')
      .doc('studentRegistration');

  bool isLoading = true;
  bool isChanged = false;
  List enabledStandards = [];

  void loadStandards(BuildContext context) async {
    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      setState(() {
        isLoading = false;
      });

      if (!settingsDocumentSnapshot.exists ||
          !settingsDocumentSnapshot.data()!.containsKey('enabledStandards')) {
        return;
      }

      setState(() {
        isChanged = false;
        enabledStandards = List<String>.from(
          settingsDocumentSnapshot.data()!['enabledStandards'],
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

  void changeStandardHandler(String standard, bool isChecked) {
    if (isChecked && !enabledStandards.contains(standard)) {
      setState(() {
        isChanged = true;
        enabledStandards.add(standard);
      });
    } else if (!isChecked) {
      setState(() {
        isChanged = true;
        enabledStandards.remove(standard);
      });
    }
  }

  void saveStandardHandler(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      await settingsDocumentReference.update(
        {'enabledStandards': enabledStandards},
      );

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

    loadStandards(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const TextAppBar(title: 'Customize Standards'),
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
                          onChanged: (isChecked) => changeStandardHandler(
                            standard,
                            isChecked,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isChanged)
                PrimaryButton(
                  title: 'Save',
                  onPressed: () => saveStandardHandler(context),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
