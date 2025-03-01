import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/alert_dialogue.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/title_icon_list.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class TutorConfigureBatchesScreen extends StatefulWidget {
  const TutorConfigureBatchesScreen({super.key});

  @override
  State<TutorConfigureBatchesScreen> createState() =>
      _TutorConfigureBatchesScreenState();
}

class _TutorConfigureBatchesScreenState
    extends State<TutorConfigureBatchesScreen> {
  final settingsDocumentReference = FirebaseFirestore.instance
      .collection('settings')
      .doc('studentRegistration');

  bool isLoading = true;
  bool isChanged = false;
  ScaffoldMessengerState? scaffoldMessengerState;
  List<String> batchNames = [];

  void loadBatches(BuildContext context) async {
    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      setState(() {
        isLoading = false;
      });

      if (!settingsDocumentSnapshot.exists) return;

      final settings = settingsDocumentSnapshot.data()!;

      if (!settings.containsKey('batchNames')) return;

      setState(() {
        isChanged = false;
        batchNames = List<String>.from(settings['batchNames']);
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
    setState(() {
      isLoading = true;
    });

    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      if (settingsDocumentSnapshot.exists) {
        await settingsDocumentReference.update({'batchNames': batchNames});
      } else {
        await settingsDocumentReference.set({'batchNames': batchNames});
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

    loadBatches(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    scaffoldMessengerState?.hideCurrentSnackBar();

    super.dispose();
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
                    function: saveBatchHandler,
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
        ),
      ),
    );
  }
}
