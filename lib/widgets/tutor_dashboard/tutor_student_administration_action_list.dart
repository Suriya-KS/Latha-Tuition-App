import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/cards/box_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_student_search_sheet.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_batch_search_sheet.dart';

class TutorStudentAdministrationActionList extends ConsumerStatefulWidget {
  const TutorStudentAdministrationActionList({super.key});

  @override
  ConsumerState<TutorStudentAdministrationActionList> createState() =>
      _TutorStudentAdministrationActionListState();
}

class _TutorStudentAdministrationActionListState
    extends ConsumerState<TutorStudentAdministrationActionList> {
  final firestore = FirebaseFirestore.instance;

  Future<List<String>> loadBatches(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final settingsDocumentSnapshot = await firestore
          .collection('settings')
          .doc('studentRegistration')
          .get();

      loadingMethods.setLoadingStatus(false);

      if (!settingsDocumentSnapshot.exists) return [];

      final settings = settingsDocumentSnapshot.data()!;

      if (!settings.containsKey('batchNames')) return [];

      return List<String>.from(
        settings['batchNames'],
      );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return [];

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );

      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadStudentsDetails(
    BuildContext context,
  ) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final studentsQuerySnapshot =
          await firestore.collection('students').orderBy('name').get();

      final fullStudentDetails = studentsQuerySnapshot.docs
          .map((studentsQueryDocumentSnapshot) => {
                'id': studentsQueryDocumentSnapshot.id,
                ...studentsQueryDocumentSnapshot.data(),
              })
          .toList();

      ref
          .read(tutorSearchProvider.notifier)
          .setFullStudentDetails(fullStudentDetails);

      final studentsDetails = studentsQuerySnapshot.docs
          .map((studentsQueryDocumentSnapshot) => {
                'id': studentsQueryDocumentSnapshot.id,
                'name': studentsQueryDocumentSnapshot.data()['name'],
                'batch': studentsQueryDocumentSnapshot.data()['batch'],
              })
          .toList();

      loadingMethods.setLoadingStatus(false);

      return studentsDetails;
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return [];

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );

      return [];
    }
  }

  void showTutorStudentSearchSheet(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final batchNames = await loadBatches(context);

      if (!context.mounted) return;

      final studentsDetails = await loadStudentsDetails(context);

      final tutorSearchMethods = ref.read(tutorSearchProvider.notifier);

      tutorSearchMethods.setBatchNames(batchNames);
      tutorSearchMethods.setStudentsDetails(studentsDetails);
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      modalBottomSheet(
        context,
        const TutorStudentSearchSheet(),
      );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void showTutorBatchSearchSheet(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final batchNames = await loadBatches(context);

      if (!context.mounted) return;

      ref.read(tutorSearchProvider.notifier).setBatchNames(batchNames);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      modalBottomSheet(
        context,
        const TutorBatchSearchSheet(),
      );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxCard(
                    title: 'Student Search',
                    image: searchImage,
                    onTap: () => showTutorStudentSearchSheet(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BoxCard(
                    title: 'Batch wise Payments',
                    image: groupPaymentImage,
                    onTap: () => showTutorBatchSearchSheet(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BoxCard(
                    title: 'New Admissions',
                    image: pendingApprovalImage,
                    onTap: () => navigateToTutorNewAdmissionsScreen(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BoxCard(
                    title: 'Payment Approval',
                    image: phoneConfirmImage,
                    onTap: () => navigateToTutorPaymentApprovalScreen(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
