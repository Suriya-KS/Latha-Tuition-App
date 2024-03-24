import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/text_edit_sheet.dart';

class TutorStudentFeedbacksView extends StatefulWidget {
  const TutorStudentFeedbacksView({super.key});

  @override
  State<TutorStudentFeedbacksView> createState() =>
      _TutorStudentFeedbacksViewState();
}

class _TutorStudentFeedbacksViewState extends State<TutorStudentFeedbacksView> {
  late List<Map<String, dynamic>> feedbacks;

  void saveFeedback(BuildContext context, String feedback, {int? index}) {
    Navigator.pop(context);

    setState(() {
      if (index != null) {
        feedbacks[index]['date'] = DateTime.now();
        feedbacks[index]['message'] = feedback;
      } else {
        feedbacks.add({
          'date': DateTime.now(),
          'message': feedback,
        });
      }
    });
  }

  void addFeedbackHandler(BuildContext context) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Edit ${capitalizeText('feedback')}',
        fieldName: 'feedback',
        buttonText: 'Save',
        inputType: TextInputType.multiline,
        onPressed: (feedback) => saveFeedback(context, feedback),
      ),
    );
  }

  void editFeedbackHandler(BuildContext context, String feedback, int index) {
    modalBottomSheet(
      context,
      TextEditSheet(
        title: 'Edit ${capitalizeText('feedback')}',
        fieldName: 'feedback',
        buttonText: 'Update',
        inputType: TextInputType.multiline,
        initialValue: feedback,
        onPressed: (feedback) => saveFeedback(context, feedback, index: index),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    feedbacks = dummyStudentFeedbacks;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
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
                  for (int i = 0; i < feedbacks.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: InfoCard(
                        icon: Icons.edit_outlined,
                        iconPosition: 'right',
                        isClickable: true,
                        onTap: () => editFeedbackHandler(
                          context,
                          feedbacks[i]['message'],
                          i,
                        ),
                        children: [
                          Text(
                            formatDate(feedbacks[i]['date']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
          FloatingCircularActionButton(
            icon: Icons.add_outlined,
            onPressed: () => addFeedbackHandler(context),
          ),
        ],
      ),
    );
  }
}
