import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_track_attendance.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_track_test_marks.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/date_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/time_input.dart';

class TutorTrackRecordSheet extends ConsumerStatefulWidget {
  const TutorTrackRecordSheet({
    this.screen,
    this.onUpdate,
    super.key,
  });

  final Screen? screen;
  final void Function()? onUpdate;

  @override
  ConsumerState<TutorTrackRecordSheet> createState() =>
      _TutorTrackRecordSheetState();
}

class _TutorTrackRecordSheetState extends ConsumerState<TutorTrackRecordSheet> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  late String title;
  late Widget destinationScreen;
  late List<bool> isSelected;

  late TextEditingController testNameController;
  late TextEditingController totalMarksController;
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void toggleTrackRecordHandler(int index) {
    ref.read(trackSheetProvider.notifier).changeActiveToggle(index);

    setState(() {
      if (index == 0) {
        title = 'Track Attendance';
        destinationScreen = const TutorTrackAttendanceScreen();
      }

      if (index == 1) {
        title = 'Track Test Marks';
        destinationScreen = const TutorTrackTestMarksScreen();
      }
    });
  }

  void changeBatchHandler(String? value) {
    if (value == null) return;

    ref.read(trackSheetProvider.notifier).setBatchName(value);
  }

  void trackRecordHandler() async {
    if (!formKey.currentState!.validate()) return;

    String testName = testNameController.text;
    double? totalMarks = double.tryParse(totalMarksController.text);
    TimeOfDay startTime = stringToTimeOfDay(startTimeController.text);
    TimeOfDay endTime = stringToTimeOfDay(endTimeController.text);
    DateTime date = DateFormat("MMMM d, yyyy").parse(dateController.text);

    final calendarViewMethods = ref.read(calendarViewProvider.notifier);
    final trackSheetMethods = ref.read(trackSheetProvider.notifier);

    trackSheetMethods.setTestName(testName);
    trackSheetMethods.setTotalMarks(totalMarks);
    calendarViewMethods.setSelectedDate(date);
    trackSheetMethods.setTime(startTime, endTime);

    if (widget.screen != Screen.attendance &&
        widget.screen != Screen.testMarks) {
      trackSheetMethods.setSelectedAttendanceID(null);
      trackSheetMethods.setSelectedTestMarksID(null);
    }

    await navigateToTrackScreen(
      context,
      widget.screen ?? Screen.tutorTrackRecordSheet,
      destinationScreen,
    );

    if (widget.onUpdate != null) widget.onUpdate!();
  }

  void deleteTrackRecordHandler(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    Navigator.pop(context);

    try {
      if (ref.read(trackSheetProvider)[TrackSheet.isBatchNameEditable]) {
        Navigator.pop(context);

        loadingMethods.setLoadingStatus(false);

        return;
      }

      final activeToggle =
          ref.read(trackSheetProvider)[TrackSheet.activeToggle];

      if (activeToggle == TrackSheetToggles.attendance) {
        final attendanceID =
            ref.read(trackSheetProvider)[TrackSheet.selectedAttendanceID];

        await firestore.collection('attendance').doc(attendanceID).delete();

        ref.read(trackSheetProvider.notifier).setSelectedAttendanceID(null);
      }

      if (activeToggle == TrackSheetToggles.tests) {
        final testMarkID =
            ref.read(trackSheetProvider)[TrackSheet.selectedTestMarksID];

        await firestore.collection('testMarks').doc(testMarkID).delete();

        ref.read(trackSheetProvider.notifier).setSelectedTestMarksID(null);
      }

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      Navigator.pop(context);
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
  void initState() {
    super.initState();

    testNameController = TextEditingController();
    totalMarksController = TextEditingController();
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();

    final trackSheetData = ref.read(trackSheetProvider);

    if (trackSheetData[TrackSheet.activeToggle] ==
        TrackSheetToggles.attendance) {
      title = 'Track Attendance';
      destinationScreen = const TutorTrackAttendanceScreen();
      isSelected = [true, false];
    }

    if (trackSheetData[TrackSheet.activeToggle] == TrackSheetToggles.tests) {
      title = 'Track Test Marks';
      destinationScreen = const TutorTrackTestMarksScreen();
      isSelected = [false, true];
    }

    if (widget.screen == Screen.attendance) {
      title = 'Attendance Details';
      startTimeController.text = formatTime(
        trackSheetData[TrackSheet.startTime],
      );
      endTimeController.text = formatTime(trackSheetData[TrackSheet.endTime]);
    }

    if (widget.screen == Screen.testMarks) {
      title = 'Test Marks Details';
      testNameController.text = trackSheetData[TrackSheet.testName];
      totalMarksController.text = formatMarks(
        trackSheetData[TrackSheet.totalMarks],
      );
      startTimeController.text =
          formatTime(trackSheetData[TrackSheet.startTime]);
      endTimeController.text = formatTime(
        trackSheetData[TrackSheet.endTime],
      );
    }
  }

  @override
  void dispose() {
    testNameController.dispose();
    totalMarksController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarViewData = ref.watch(calendarViewProvider);
    final trackSheetData = ref.watch(trackSheetProvider);
    final isEditMode =
        widget.screen == Screen.attendance || widget.screen == Screen.testMarks;

    return Column(
      children: [
        TitleText(title: title),
        if (!isEditMode) const SizedBox(height: 50),
        Form(
          key: formKey,
          child: Column(
            children: [
              if (!isEditMode)
                ToggleInput(
                  isSelected: isSelected,
                  onToggle: toggleTrackRecordHandler,
                  children: const [
                    Icon(Icons.groups_outlined),
                    Icon(Icons.assignment_outlined),
                  ],
                ),
              if (trackSheetData[TrackSheet.activeToggle] ==
                  TrackSheetToggles.tests)
                const SizedBox(height: 10),
              if (trackSheetData[TrackSheet.activeToggle] ==
                  TrackSheetToggles.tests)
                TextInput(
                  labelText: 'Test Name',
                  prefixIcon: Icons.assignment_outlined,
                  inputType: TextInputType.text,
                  initialValue: testNameController.text,
                  controller: testNameController,
                  validator: (value) => validateRequiredInput(
                    value,
                    'the',
                    'test name',
                  ),
                ),
              const SizedBox(height: 10),
              if (trackSheetData[TrackSheet.activeToggle] ==
                      TrackSheetToggles.attendance &&
                  trackSheetData[TrackSheet.isBatchNameEditable])
                DropdownInput(
                  initialValue: widget.screen == Screen.attendance
                      ? trackSheetData[TrackSheet.batchName]
                      : null,
                  labelText: 'Batch',
                  prefixIcon: Icons.groups_outlined,
                  items: trackSheetData[TrackSheet.batchNames],
                  onChanged: changeBatchHandler,
                  validator: validateDropdownValue,
                ),
              if (trackSheetData[TrackSheet.activeToggle] ==
                  TrackSheetToggles.tests)
                Row(
                  children: [
                    Expanded(
                      child: TextInput(
                        labelText: 'Total Marks',
                        prefixIcon: Icons.equalizer_outlined,
                        inputType: TextInputType.number,
                        initialValue: totalMarksController.text,
                        controller: totalMarksController,
                        validator: (value) => validateTotalMarks(
                          totalMarksController.text,
                        ),
                      ),
                    ),
                    if (trackSheetData[TrackSheet.isBatchNameEditable])
                      const SizedBox(width: 30),
                    if (trackSheetData[TrackSheet.isBatchNameEditable])
                      Expanded(
                        child: DropdownInput(
                          initialValue: widget.screen == Screen.testMarks
                              ? trackSheetData[TrackSheet.batchName]
                              : null,
                          labelText: 'Batch',
                          prefixIcon: Icons.groups_outlined,
                          items: trackSheetData[TrackSheet.batchNames],
                          onChanged: changeBatchHandler,
                          validator: validateDropdownValue,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 10),
              DateInput(
                labelText: 'Date',
                prefixIcon: Icons.calendar_month_outlined,
                initialDate: calendarViewData[CalendarView.selectedDate],
                firstDate: calendarViewData[CalendarView.firstDate],
                lastDate: calendarViewData[CalendarView.lastDate],
                controller: dateController,
                validator: (value) => validateRequiredInput(value, 'a', 'date'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TimeInput(
                      labelText: 'Start Time',
                      prefixIcon: Icons.alarm_outlined,
                      initialTime: trackSheetData[TrackSheet.startTime],
                      controller: startTimeController,
                      validator: (value) => validateRequiredInput(
                        value,
                        'a',
                        'start time',
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TimeInput(
                      labelText: 'End Time',
                      prefixIcon: Icons.alarm_outlined,
                      initialTime: trackSheetData[TrackSheet.endTime],
                      controller: endTimeController,
                      validator: (value) => validateRequiredInput(
                        value,
                        'an',
                        'end time',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: isEditMode
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (isEditMode)
                    PrimaryButton(
                      title: 'Delete',
                      isOutlined: true,
                      onPressed: () => deleteTrackRecordHandler(context),
                    ),
                  PrimaryButton(
                    title: isEditMode ? 'Update' : 'Track',
                    onPressed: trackRecordHandler,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: screenPadding),
      ],
    );
  }
}
