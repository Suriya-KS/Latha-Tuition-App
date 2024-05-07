import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/alert_dialogue.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/utilities/tutor_track_record_details.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class TutorTrackTestMarksScreen extends ConsumerStatefulWidget {
  const TutorTrackTestMarksScreen({
    this.testMarks,
    super.key,
  });

  final List<Map<String, dynamic>>? testMarks;

  @override
  ConsumerState<TutorTrackTestMarksScreen> createState() =>
      _TutorTrackTestMarksScreenState();
}

class _TutorTrackTestMarksScreenState
    extends ConsumerState<TutorTrackTestMarksScreen> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isChanged = false;
  List<Map<String, dynamic>> testMarks = [];
  List<TextEditingController> marksControllers = [];

  void loadBatchStudents(
    BuildContext context, {
    bool isUpdated = false,
  }) async {
    setState(() {
      isLoading = true;
      if (isUpdated) isChanged = true;
    });

    final batchName = ref.read(trackSheetProvider)[TrackSheet.batchName];

    List<Map<String, dynamic>> studentTestMarks = [];

    try {
      if (widget.testMarks != null) {
        final studentIDs =
            widget.testMarks!.map((testMark) => testMark['studentID']).toList();

        final studentsQuerySnapshot = await firestore
            .collection('students')
            .where(FieldPath.documentId, whereIn: studentIDs)
            .get();

        final studentIDsAndNames =
            studentsQuerySnapshot.docs.map((studentsQueryDocumentSnapshot) => {
                  'studentID': studentsQueryDocumentSnapshot.id,
                  'studentName': studentsQueryDocumentSnapshot.data()['name'],
                });

        for (final student in studentIDsAndNames) {
          final marks = widget.testMarks!.firstWhere(
            (mark) => mark['studentID'] == student['studentID'],
            orElse: () => {'marks': null},
          );

          if (marks == marks['marks']) continue;

          studentTestMarks.add({
            'studentID': student['studentID'],
            'studentName': student['studentName'],
            'marks': marks['marks'],
          });
        }
      } else {
        final studentsQuerySnapshot = await firestore
            .collection('students')
            .where('batch', isEqualTo: batchName)
            .get();

        studentTestMarks = studentsQuerySnapshot.docs
            .map((studentsQueryDocumentSnapshot) => {
                  'studentID': studentsQueryDocumentSnapshot.id,
                  'studentName': studentsQueryDocumentSnapshot.data()['name'],
                  'marks': null,
                })
            .toList();
      }

      setState(() {
        isLoading = false;
        testMarks = studentTestMarks;
        marksControllers = List.generate(
          studentTestMarks.length,
          (index) => TextEditingController(
              text: testMarks[index]['marks'] != null
                  ? testMarks[index]['marks'].toString()
                  : ''),
        );
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

  void marksChangeHandler(String marks, int listIndex) {
    testMarks[listIndex]['marks'] = num.tryParse(marks);

    setState(() {
      isChanged = true;
    });
  }

  void trackTestMarksHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final trackSheetData = ref.read(trackSheetProvider);
    final date = ref.read(calendarViewProvider)[CalendarView.selectedDate];
    final testMarksID = trackSheetData[TrackSheet.selectedTestMarksID];
    final testMarksRecord = {
      'name': trackSheetData[TrackSheet.testName],
      'batch': trackSheetData[TrackSheet.batchName],
      'date': date,
      'startTime': timeOfDayToTimestamp(
        date,
        trackSheetData[TrackSheet.startTime],
      ),
      'endTime': timeOfDayToTimestamp(date, trackSheetData[TrackSheet.endTime]),
      'marks': testMarks.map((testMark) => {
            'studentID': testMark['studentID'],
            'marks': testMark['marks'],
          }),
      'totalMarks': trackSheetData[TrackSheet.totalMarks],
    };

    try {
      if (testMarksID != null) {
        await firestore
            .collection('testMarks')
            .doc(testMarksID)
            .update(testMarksRecord);

        ref.read(trackSheetProvider.notifier).setSelectedTestMarksID(null);
      } else {
        await firestore.collection('testMarks').add(testMarksRecord);
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

    loadBatchStudents(context);
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
    final canSave =
        (widget.testMarks == null || isChanged) && testMarks.isNotEmpty;

    return PopScope(
      canPop: !canSave,
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
                    function: trackTestMarksHandler,
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          : null,
      child: LoadingOverlay(
        isLoading: isLoading,
        child: ScrollableDetailsList(
          title: 'Track Test Marks',
          onPressed: canSave ? () => trackTestMarksHandler(context) : null,
          children: [
            TutorTrackRecordDetails(
              title: trackSheetData[TrackSheet.testName],
              description: trackSheetData[TrackSheet.batchName],
              totalMarks: trackSheetData[TrackSheet.totalMarks],
              date: calendarViewData[CalendarView.selectedDate],
              startTime: trackSheetData[TrackSheet.startTime],
              endTime: trackSheetData[TrackSheet.endTime],
              screen: Screen.testMarks,
              onEdit: () => loadBatchStudents(context, isUpdated: true),
            ),
            const SizedBox(height: 10),
            testMarks.isEmpty
                ? Expanded(
                    child: ImageWithCaption(
                      imagePath:
                          Theme.of(context).brightness == Brightness.light
                              ? notFoundImage
                              : notFoundImageDark,
                      description: 'No students found!',
                    ),
                  )
                : Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView.builder(
                        itemCount: testMarks.length + 1,
                        itemBuilder: (context, index) => index <
                                testMarks.length
                            ? TextAvatarActionCard(
                                action: SizedBox(
                                  width: 120,
                                  child: TextInput(
                                    labelText: 'Marks',
                                    prefixIcon: Icons.assignment_outlined,
                                    inputType: TextInputType.number,
                                    initialValue: testMarks[index]['marks'] !=
                                            null
                                        ? testMarks[index]['marks'].toString()
                                        : '',
                                    onChanged: (marks) => marksChangeHandler(
                                      marks,
                                      index,
                                    ),
                                    controller: marksControllers[index],
                                    validator: (value) => validateMarks(
                                      marksControllers[index].text,
                                      trackSheetData[TrackSheet.totalMarks]
                                          .toString(),
                                    ),
                                  ),
                                ),
                                children: [
                                  Text(
                                    testMarks[index]['studentName'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : const SizedBox(height: 120),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
