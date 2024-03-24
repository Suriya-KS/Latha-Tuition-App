import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/test_marks_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/title_input_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class TutorStudentTestMarksView extends ConsumerStatefulWidget {
  const TutorStudentTestMarksView({super.key});

  @override
  ConsumerState<TutorStudentTestMarksView> createState() =>
      _TutorStudentTestMarksViewState();
}

class _TutorStudentTestMarksViewState
    extends ConsumerState<TutorStudentTestMarksView> {
  late int length;
  late List<TextEditingController> marksControllers;

  @override
  void initState() {
    super.initState();

    final testMarksList = ref.read(testMarksProvider);

    length = testMarksList.length;
    marksControllers = List.generate(
      length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final marksController in marksControllers) {
      marksController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> testMarksList = ref.watch(testMarksProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Stack(
          children: [
            Column(
              children: [
                MonthInput(
                  onChange: (date) {},
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: length + 1,
                    itemBuilder: (context, index) => index < length
                        ? TitleInputCard(
                            title: testMarksList[index]['name'],
                            description: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total Marks: '),
                                    Text(
                                      '${testMarksList[index]['totalMarks']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(formatDate(testMarksList[index]['date'])),
                                Text(testMarksList[index]['time']),
                              ],
                            ),
                            input: SizedBox(
                              width: 120,
                              child: TextInput(
                                labelText: 'Marks',
                                prefixIcon: Icons.assignment_outlined,
                                inputType: TextInputType.number,
                                initialValue:
                                    testMarksList[index]['marks'].toString(),
                                controller: marksControllers[index],
                                validator: (value) => validateMarks(
                                  marksControllers[index].text,
                                  100.toString(),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 120),
                  ),
                ),
              ],
            ),
            FloatingCircularActionButton(
              icon: Icons.check_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
