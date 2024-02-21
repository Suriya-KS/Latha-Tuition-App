import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/screens/attendance.dart';
import 'package:latha_tuition_app/screens/test_marks.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/date_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/time_input.dart';

class TrackRecordSheet extends ConsumerStatefulWidget {
  const TrackRecordSheet({
    this.screen,
    super.key,
  });

  final Screen? screen;

  @override
  ConsumerState<TrackRecordSheet> createState() => _TrackRecordSheetState();
}

class _TrackRecordSheetState extends ConsumerState<TrackRecordSheet> {
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
    List<String> splitString = timeString.split(':');
    int hour = int.parse(splitString[0]);
    int minute = int.parse(splitString[1].split(' ')[0]);
    String period = splitString[1].split(' ')[1];

    if (period.toLowerCase() == 'pm') hour += 12;

    return TimeOfDay(hour: hour, minute: minute);
  }

  void toggleHandler(int index) {
    ref.read(trackSheetProvider.notifier).changeActiveToggle(index);

    setState(() {
      if (index == 0) {
        title = 'Track Attendance';
        destinationScreen = const AttendanceScreen();
      }

      if (index == 1) {
        title = 'Track Test Marks';
        destinationScreen = const TestMarksScreen();
      }
    });
  }

  void dropdownChangeHandler(String? value) {
    if (value == null) return;

    ref.read(trackSheetProvider.notifier).setBatchName(value);
  }

  void submitHandler() {
    if (formKey.currentState!.validate()) {
      String testName = testNameController.text;
      double? totalMarks = double.tryParse(totalMarksController.text);
      TimeOfDay startTime = stringToTimeOfDay(startTimeController.text);
      TimeOfDay endTime = stringToTimeOfDay(endTimeController.text);
      DateTime date = DateFormat("MMMM d, yyyy").parse(dateController.text);

      final calendarViewMethods = ref.read(calendarViewProvider.notifier);
      final trackSheetMethods = ref.read(trackSheetProvider.notifier);
      final attendanceMethods = ref.read(attendanceProvider.notifier);

      trackSheetMethods.setTestName(testName);
      trackSheetMethods.setTotalMarks(totalMarks);
      calendarViewMethods.setSelectedDate(date);
      trackSheetMethods.setTime(startTime, endTime);
      attendanceMethods.startAttendanceTracker(dummyStudentNames.length);

      navigateToTrackScreen(
        context,
        widget.screen ?? Screen.trackRecordSheet,
        destinationScreen,
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
      destinationScreen = const AttendanceScreen();
      isSelected = [true, false];
    }

    if (trackSheetData[TrackSheet.activeToggle] == TrackSheetToggles.tests) {
      title = 'Track Test Marks';
      destinationScreen = const TestMarksScreen();
      isSelected = [false, true];
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

    if (widget.screen == Screen.attendance) {
      title = 'Attendance Details';
      startTimeController.text =
          formatTime(trackSheetData[TrackSheet.startTime]);
      endTimeController.text = formatTime(trackSheetData[TrackSheet.endTime]);
    }

    if (widget.screen == Screen.testMarks) {
      title = 'Test Marks Details';
      testNameController.text = trackSheetData[TrackSheet.testName];
      totalMarksController.text =
          formatMarks(trackSheetData[TrackSheet.totalMarks]);
      startTimeController.text =
          formatTime(trackSheetData[TrackSheet.startTime]);
      endTimeController.text = formatTime(trackSheetData[TrackSheet.endTime]);
    }

    return Column(
      children: [
        TitleText(title: title),
        if (widget.screen != Screen.attendance &&
            widget.screen != Screen.testMarks)
          const SizedBox(height: 50),
        Form(
          key: formKey,
          child: Column(
            children: [
              if (widget.screen != Screen.attendance &&
                  widget.screen != Screen.testMarks)
                ToggleInput(
                  labelTextLeft: 'Track \nAttendance',
                  labelTextRight: 'Track \nTest Marks',
                  iconLeft: Icons.groups_outlined,
                  iconRight: Icons.assignment_outlined,
                  isSelected: isSelected,
                  onToggle: toggleHandler,
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
                  controller: testNameController,
                  validator: (value) =>
                      validateRequiredInput(value, 'the', 'test name'),
                ),
              const SizedBox(height: 10),
              if (trackSheetData[TrackSheet.activeToggle] ==
                  TrackSheetToggles.attendance)
                DropdownInput(
                  initialValue: widget.screen == Screen.attendance
                      ? trackSheetData[TrackSheet.batchName]
                      : null,
                  labelText: 'Batch',
                  prefixIcon: Icons.groups_outlined,
                  items: dummyBatchNames,
                  onChanged: dropdownChangeHandler,
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
                        controller: totalMarksController,
                        validator: (value) =>
                            validateTotalMarks(totalMarksController.text),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: DropdownInput(
                        initialValue: widget.screen == Screen.testMarks
                            ? trackSheetData[TrackSheet.batchName]
                            : null,
                        labelText: 'Batch',
                        prefixIcon: Icons.groups_outlined,
                        items: dummyBatchNames,
                        onChanged: dropdownChangeHandler,
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
                      validator: (value) =>
                          validateRequiredInput(value, 'a', 'start time'),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TimeInput(
                      labelText: 'End Time',
                      prefixIcon: Icons.alarm_outlined,
                      initialTime: trackSheetData[TrackSheet.endTime],
                      controller: endTimeController,
                      validator: (value) =>
                          validateTimeRange(startTimeController.text, value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                title: widget.screen == Screen.attendance ||
                        widget.screen == Screen.testMarks
                    ? 'Update'
                    : 'Track',
                onPressed: submitHandler,
              ),
            ],
          ),
        ),
        const SizedBox(height: screenPadding),
      ],
    );
  }
}
