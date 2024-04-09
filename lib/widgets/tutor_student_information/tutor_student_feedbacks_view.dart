import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/text_edit_sheet.dart';

class TutorStudentFeedbacksView extends ConsumerStatefulWidget {
  const TutorStudentFeedbacksView({super.key});

  @override
  ConsumerState<TutorStudentFeedbacksView> createState() =>
      _TutorStudentFeedbacksViewState();
}

class _TutorStudentFeedbacksViewState
    extends ConsumerState<TutorStudentFeedbacksView> {
  final feedbacksCollectionReference =
      FirebaseFirestore.instance.collection('feedbacks');

  List<Map<String, dynamic>> studentFeedbacks = [];

  Future<void> loadStudentFeedbacks(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];

    try {
      final studentFeedbacksQuerySnapshot = await feedbacksCollectionReference
          .where('studentID', isEqualTo: studentID)
          .orderBy('date', descending: true)
          .get();

      loadingMethods.setLoadingStatus(false);

      setState(() {
        studentFeedbacks = studentFeedbacksQuerySnapshot.docs
            .map((studentPaymentQueryDocumentSnapshot) => {
                  ...studentPaymentQueryDocumentSnapshot.data(),
                  'date':
                      (studentPaymentQueryDocumentSnapshot['date'] as Timestamp)
                          .toDate(),
                  'id': studentPaymentQueryDocumentSnapshot.id,
                })
            .toList();
      });
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void saveFeedback(
    BuildContext context,
    String feedback, {
    String? id,
  }) async {
    Navigator.pop(context);

    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];

    try {
      if (id == null) {
        await feedbacksCollectionReference.add({
          'message': feedback,
          'date': DateTime.now(),
          'studentID': studentID,
          'notifyParent': true,
        });
      } else {
        await feedbacksCollectionReference.doc(id).update({
          'message': feedback,
          'date': DateTime.now(),
          'notifyParent': true,
        });
      }

      if (!context.mounted) return;

      await loadStudentFeedbacks(context);
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void deleteFeedback(BuildContext context, String id) async {
    Navigator.pop(context);

    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await feedbacksCollectionReference.doc(id).delete();

      if (!context.mounted) return;

      await loadStudentFeedbacks(context);
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void addFeedbackHandler(BuildContext context) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Add ${capitalizeText('feedback')}',
        fieldName: 'feedback',
        buttonText: 'Save',
        inputType: TextInputType.multiline,
        onPressed: (feedback) => saveFeedback(context, feedback),
      ),
    );
  }

  void editFeedbackHandler(BuildContext context, String feedback, String id) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Edit ${capitalizeText('feedback')}',
        fieldName: 'feedback',
        buttonText: 'Update',
        secondaryButton: PrimaryButton(
          title: 'Delete',
          isOutlined: true,
          onPressed: () => deleteFeedback(context, id),
        ),
        inputType: TextInputType.multiline,
        initialValue: feedback,
        onPressed: (feedback) => saveFeedback(context, feedback, id: id),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadStudentFeedbacks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: screenPadding,
                right: screenPadding,
                bottom: 100,
                left: screenPadding,
              ),
              child: Column(
                children: [
                  for (int i = 0; i < studentFeedbacks.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: InfoCard(
                        icon: Icons.edit_outlined,
                        iconPosition: 'right',
                        isClickable: true,
                        onTap: () => editFeedbackHandler(
                          context,
                          studentFeedbacks[i]['message'],
                          studentFeedbacks[i]['id'],
                        ),
                        children: [
                          Text(
                            formatDate(studentFeedbacks[i]['date']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(studentFeedbacks[i]['message']),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          FloatingCircularActionButton(
            icon: Icons.add_outlined,
            onPressed: () => addFeedbackHandler(context),
          ),
        ],
      ),
    );
  }
}
