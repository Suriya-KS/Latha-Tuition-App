import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';

class StudentFeedbacksScreen extends ConsumerStatefulWidget {
  const StudentFeedbacksScreen({super.key});

  @override
  ConsumerState<StudentFeedbacksScreen> createState() =>
      _StudentFeedbacksScreenState();
}

class _StudentFeedbacksScreenState
    extends ConsumerState<StudentFeedbacksScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  List<Map<String, dynamic>> feedbacks = [];

  Future<void> loadStudentFeedbacks(BuildContext context) async {
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    try {
      QuerySnapshot feedbackQuerySnapshot = await firestore
          .collection('feedbacks')
          .where('studentID', isEqualTo: studentID)
          .where('notifyStudent', isEqualTo: true)
          .get();

      final batch = firestore.batch();

      for (final feedbackQueryDocumentSnapshot in feedbackQuerySnapshot.docs) {
        batch.update(
          feedbackQueryDocumentSnapshot.reference,
          {'notifyStudent': false},
        );
      }

      await batch.commit();

      feedbackQuerySnapshot = await firestore
          .collection('feedbacks')
          .where('studentID', isEqualTo: studentID)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        isLoading = false;
        feedbacks = (feedbackQuerySnapshot.docs
                as List<QueryDocumentSnapshot<Map<String, dynamic>>>)
            .map((feedbackDocumentSnapshot) => {
                  ...feedbackDocumentSnapshot.data(),
                  'date':
                      (feedbackDocumentSnapshot['date'] as Timestamp).toDate(),
                  'id': feedbackDocumentSnapshot.id,
                })
            .toList();
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

  @override
  void initState() {
    super.initState();

    loadStudentFeedbacks(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const TextAppBar(title: 'Feedbacks'),
        body: SafeArea(
          child: Column(
            children: [
              feedbacks.isEmpty
                  ? Expanded(
                      child: ImageWithCaption(
                        imagePath:
                            Theme.of(context).brightness == Brightness.light
                                ? notFoundImage
                                : notFoundImageDark,
                        description: 'No feedbacks found!',
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: screenPadding,
                          right: screenPadding,
                          bottom: 100,
                          left: screenPadding,
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < feedbacks.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: InfoCard(
                                  icon: null,
                                  children: [
                                    Text(
                                      formatDate(feedbacks[i]['date']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(feedbacks[i]['message']),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
