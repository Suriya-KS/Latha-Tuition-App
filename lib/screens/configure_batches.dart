import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class ConfigureBatchesScreen extends StatefulWidget {
  const ConfigureBatchesScreen({super.key});

  @override
  State<ConfigureBatchesScreen> createState() => _ConfigureBatchesScreenState();
}

class _ConfigureBatchesScreenState extends State<ConfigureBatchesScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isChanged = false;
  List<String> batchNames = [];

  void loadBatches() async {
    final documentSnapshot =
        await firestore.collection('settings').doc('studentRegistration').get();

    setState(() {
      isChanged = false;
      batchNames = List<String>.from(documentSnapshot.data()!['batchNames']);
    });
  }

  void addBatchHandler(String batchName) {
    setState(() {
      isChanged = true;
      batchNames.add(batchName);
    });

    Navigator.pop(context);
  }

  void editBatchHandler(int index, String batchName) {
    setState(() {
      isChanged = true;
      batchNames[index] = batchName;
    });

    Navigator.pop(context);
  }

  void deleteBatchHandler(int index) {
    final batchName = batchNames[index];

    snackBar(
      context,
      content: Text('Batch "$batchName" has been deleted'),
      actionLabel: 'Undo',
      onPressed: () => setState(() {
        batchNames.insert(index, batchName);
      }),
    );

    setState(() {
      isChanged = true;
      batchNames.removeAt(index);
    });
  }

  void saveBatchHandler(BuildContext context) async {
    final documentReference =
        firestore.collection('settings').doc('studentRegistration');

    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      await documentReference.update({'batchNames': batchNames});
    } else {
      await documentReference.set({'batchNames': batchNames});
    }

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    loadBatches();
  }

  @override
  Widget build(BuildContext context) {
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
                items: batchNames,
                onListTileTap: (index, batchName) => editBatchHandler(
                  index,
                  batchName,
                ),
                onIconPressAndSwipe: (index) => deleteBatchHandler(index),
                onButtonPress: (batchName) => addBatchHandler(batchName),
              ),
            ),
            const SizedBox(height: 20),
            if (isChanged)
              PrimaryButton(
                title: 'Save',
                onPressed: () => saveBatchHandler(context),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
