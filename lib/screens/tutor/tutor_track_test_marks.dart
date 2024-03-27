import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/providers/test_marks_provider.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/utilities/tutor_track_record_details.dart';

class TutorTrackTestMarksScreen extends ConsumerStatefulWidget {
  const TutorTrackTestMarksScreen({super.key});

  @override
  ConsumerState<TutorTrackTestMarksScreen> createState() =>
      _TutorTrackTestMarksScreenState();
}

class _TutorTrackTestMarksScreenState
    extends ConsumerState<TutorTrackTestMarksScreen> {
  late int length;
  late List<TextEditingController> marksControllers;

  void trackMarksHandler(BuildContext context) {
    Navigator.pop(context);
  }

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
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);
    final List<dynamic> testMarksList = ref.watch(testMarksProvider);

    return ScrollableDetailsList(
      title: 'Track Test Marks',
      onPressed: () => trackMarksHandler(context),
      children: [
        TutorTrackRecordDetails(
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
                ? TextAvatarActionCard(
                    title: testMarksList[index]['name'],
                    action: SizedBox(
                      width: 120,
                      child: TextInput(
                        labelText: 'Marks',
                        prefixIcon: Icons.assignment_outlined,
                        inputType: TextInputType.number,
                        initialValue: testMarksList[index]['marks'].toString(),
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
