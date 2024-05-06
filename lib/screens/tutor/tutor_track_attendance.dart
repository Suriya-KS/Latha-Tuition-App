import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/alert_dialogue.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/utilities/tutor_track_record_details.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_details_list.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';

class TutorTrackAttendanceScreen extends ConsumerStatefulWidget {
  const TutorTrackAttendanceScreen({
    this.attendanceList,
    super.key,
  });

  final List<Map<String, dynamic>>? attendanceList;

  @override
  ConsumerState<TutorTrackAttendanceScreen> createState() =>
      _TutorTrackAttendanceScreenState();
}

class _TutorTrackAttendanceScreenState
    extends ConsumerState<TutorTrackAttendanceScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool isChanged = false;
  List<Map<String, dynamic>> attendanceList = [];

  void loadBatchStudents(
    BuildContext context, {
    bool isUpdated = false,
  }) async {
    setState(() {
      isLoading = true;
      if (isUpdated) isChanged = true;
    });

    final batchName = ref.read(trackSheetProvider)[TrackSheet.batchName];

    List<Map<String, dynamic>> studentAttendanceList = [];

    try {
      if (widget.attendanceList != null) {
        final studentIDs = widget.attendanceList!
            .map((attendance) => attendance['studentID'])
            .toList();

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
          final status = widget.attendanceList!.firstWhere(
            (status) => status['studentID'] == student['studentID'],
            orElse: () => {'status': null},
          );

          if (status['status'] == null) continue;

          studentAttendanceList.add({
            'studentID': student['studentID'],
            'studentName': student['studentName'],
            'status': status['status']
          });
        }
      } else {
        final studentsQuerySnapshot = await firestore
            .collection('students')
            .where('batch', isEqualTo: batchName)
            .get();

        studentAttendanceList = studentsQuerySnapshot.docs
            .map((studentsQueryDocumentSnapshot) => {
                  'studentID': studentsQueryDocumentSnapshot.id,
                  'studentName': studentsQueryDocumentSnapshot.data()['name'],
                  'status': 'present',
                })
            .toList();
      }

      setState(() {
        isLoading = false;
        attendanceList = studentAttendanceList;
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

  void attendanceStatusToggleHandler(int toggleIndex, int listIndex) {
    attendanceList[listIndex]['status'] =
        toggleIndex == 0 ? 'present' : 'absent';

    setState(() {
      isChanged = true;
    });
  }

  void trackAttendanceHandler(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final trackSheetData = ref.read(trackSheetProvider);
    final date = ref.read(calendarViewProvider)[CalendarView.selectedDate];
    final attendanceID = trackSheetData[TrackSheet.selectedAttendanceID];
    final attendanceRecord = {
      'batch': trackSheetData[TrackSheet.batchName],
      'date': date,
      'startTime': timeOfDayToTimestamp(
        date,
        trackSheetData[TrackSheet.startTime],
      ),
      'endTime': timeOfDayToTimestamp(date, trackSheetData[TrackSheet.endTime]),
      'attendance': attendanceList.map((attendance) => {
            'studentID': attendance['studentID'],
            'status': attendance['status'],
          }),
    };

    try {
      if (attendanceID != null) {
        await firestore
            .collection('attendance')
            .doc(attendanceID)
            .update(attendanceRecord);

        ref.read(trackSheetProvider.notifier).setSelectedAttendanceID(null);
      } else {
        await firestore.collection('attendance').add(attendanceRecord);
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
  Widget build(BuildContext context) {
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);
    final canSave = (widget.attendanceList == null || isChanged) &&
        attendanceList.isNotEmpty;

    return PopScope(
      canPop: !canSave,
      onPopInvoked: (didPop) => alertDialogue(
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
              function: trackAttendanceHandler,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
      child: LoadingOverlay(
        isLoading: isLoading,
        child: ScrollableDetailsList(
          title: 'Track Attendance',
          onPressed: canSave ? () => trackAttendanceHandler(context) : null,
          children: [
            TutorTrackRecordDetails(
              title: trackSheetData[TrackSheet.batchName],
              date: calendarViewData[CalendarView.selectedDate],
              startTime: trackSheetData[TrackSheet.startTime],
              endTime: trackSheetData[TrackSheet.endTime],
              screen: Screen.attendance,
              onEdit: () => loadBatchStudents(context, isUpdated: true),
            ),
            const SizedBox(height: 10),
            attendanceList.isEmpty
                ? ImageWithCaption(
                    imagePath: Theme.of(context).brightness == Brightness.light
                        ? notFoundImage
                        : notFoundImageDark,
                    description: 'No students found!',
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: attendanceList.length + 1,
                      itemBuilder: (context, index) => index <
                              attendanceList.length
                          ? TextAvatarActionCard(
                              action: ToggleInput(
                                backgroundColors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.error,
                                ],
                                isSelected:
                                    attendanceList[index]['status'] == 'present'
                                        ? [true, false]
                                        : [false, true],
                                onToggle: (toggleIndex) =>
                                    attendanceStatusToggleHandler(
                                  toggleIndex,
                                  index,
                                ),
                                children: const [
                                  Icon(Icons.check),
                                  Icon(Icons.close),
                                ],
                              ),
                              children: [
                                Text(
                                  attendanceList[index]['studentName'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : const SizedBox(height: 120),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
