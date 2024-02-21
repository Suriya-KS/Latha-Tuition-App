import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/cards/title_input_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/utilities/track_record_details.dart';

class TestMarksScreen extends ConsumerStatefulWidget {
  const TestMarksScreen({super.key});

  @override
  ConsumerState<TestMarksScreen> createState() => _TestMarksScreenState();
}

class _TestMarksScreenState extends ConsumerState<TestMarksScreen> {
  late int length;
  late List<TextEditingController> marksControllers;

  void submitHandler(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    length = dummyStudentNames.length;
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
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);

    return ScrollableDetailsList(
      title: 'Track Test Marks',
      onPressed: () => submitHandler(context),
      children: [
        TrackRecordDetails(
          title: trackSheetData[TrackSheet.testName],
          description: trackSheetData[TrackSheet.batchName],
          totalMarks: trackSheetData[TrackSheet.totalMarks],
          date: calendarViewData[CalendarView.selectedDate],
          startTime: trackSheetData[TrackSheet.startTime],
          endTime: trackSheetData[TrackSheet.endTime],
          screen: Screen.testMarks,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: length + 1,
            itemBuilder: (context, index) => index < length
                ? TitleInputCard(
                    title: dummyStudentNames[index],
                    input: SizedBox(
                      width: 120,
                      child: TextInput(
                        labelText: 'Marks',
                        prefixIcon: Icons.assignment_outlined,
                        inputType: TextInputType.number,
                        controller: marksControllers[index],
                        validator: (value) => validateMarks(
                          marksControllers[index].text,
                          trackSheetData[TrackSheet.totalMarks].toString(),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 120),
          ),
        ),
      ],
    );
  }
}
