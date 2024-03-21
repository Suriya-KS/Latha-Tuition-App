import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureStandardsScreen extends StatefulWidget {
  const ConfigureStandardsScreen({super.key});

  @override
  State<ConfigureStandardsScreen> createState() =>
      _ConfigureStandardsScreenState();
}

class _ConfigureStandardsScreenState extends State<ConfigureStandardsScreen> {
  final firestore = FirebaseFirestore.instance;
  final standards = [
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

  bool isChanged = false;
  List enabledStandards = [];

  void loadStandards() async {
    final documentSnapshot =
        await firestore.collection('settings').doc('studentRegistration').get();

    setState(() {
      isChanged = false;
      enabledStandards = List<String>.from(
        documentSnapshot.data()!['enabledStandards'],
      );
    });
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
    await firestore
        .collection('settings')
        .doc('studentRegistration')
        .update({'enabledStandards': enabledStandards});

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    loadStandards();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
