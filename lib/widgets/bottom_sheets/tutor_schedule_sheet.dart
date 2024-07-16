import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/schedule_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/date_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/time_input.dart';

class TutorScheduleSheet extends ConsumerStatefulWidget {
  const TutorScheduleSheet({super.key});

  @override
  ConsumerState<TutorScheduleSheet> createState() => _TutorScheduleSheetState();
}

class _TutorScheduleSheetState extends ConsumerState<TutorScheduleSheet> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  late String title;
  late String batchName;
  late List<bool> isSelected;
  late TextEditingController testNameController;
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  void toggleScheduleHandler(int index) {
    ref.read(scheduleProvider.notifier).changeActiveToggle(index);

    setState(() {
      if (index == 0) title = 'Schedule Class';
      if (index == 1) title = 'Schedule Test';
    });
  }

  void changeBatchHandler(String? value) {
    if (value == null) return;

    batchName = value;
  }

  void scheduleSheetHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    String testName = testNameController.text;
    DateTime date = DateFormat("MMMM d, yyyy").parse(dateController.text);
    TimeOfDay startTime = stringToTimeOfDay(startTimeController.text);
    TimeOfDay endTime = stringToTimeOfDay(endTimeController.text);
    Map<String, Object> scheduleRecord = {
      'batch': batchName,
      'date': date,
      'startTime': timeOfDayToTimestamp(
        date,
        startTime,
      ),
      'endTime': timeOfDayToTimestamp(
        date,
        endTime,
      ),
    };

    final scheduleData = ref.read(scheduleProvider);
    final loadingMethods = ref.read(loadingProvider.notifier);

    Navigator.pop(context, true);

    loadingMethods.setLoadingStatus(true);

    try {
      if (scheduleData[Schedule.activeToggle] == ScheduleToggles.classes) {
        await firestore.collection('upcomingClasses').add(scheduleRecord);
      } else if (scheduleData[Schedule.activeToggle] == ScheduleToggles.tests) {
        scheduleRecord = {
          'name': testName,
          ...scheduleRecord,
        };

        await firestore.collection('scheduledTests').add(scheduleRecord);
      }

      loadingMethods.setLoadingStatus(false);
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
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();

    final scheduleData = ref.read(scheduleProvider);

    if (scheduleData[Schedule.activeToggle] == ScheduleToggles.classes) {
      title = 'Schedule Class';
      isSelected = [true, false];
    }

    if (scheduleData[Schedule.activeToggle] == ScheduleToggles.tests) {
      title = 'Schedule Test';
      isSelected = [false, true];
    }
  }

  @override
  void dispose() {
    testNameController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarViewData = ref.watch(calendarViewProvider);
    final batchNames = ref.watch(scheduleProvider)[Schedule.batchNames];
    final scheduleData = ref.read(scheduleProvider);

    return Column(
      children: [
        TitleText(title: title),
        const SizedBox(height: 20),
        Form(
          key: formKey,
          child: Column(
            children: [
              ToggleInput(
                isSelected: isSelected,
                onToggle: toggleScheduleHandler,
                children: const [
                  Icon(Icons.groups_outlined),
                  Icon(Icons.assignment_outlined),
                ],
              ),
              if (scheduleData[Schedule.activeToggle] == ScheduleToggles.tests)
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
              DropdownInput(
                labelText: 'Batch',
                prefixIcon: Icons.groups_outlined,
                items: batchNames,
                onChanged: changeBatchHandler,
                validator: validateDropdownValue,
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
                      initialTime: scheduleData[Schedule.startTime],
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
                      initialTime: scheduleData[Schedule.endTime],
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
              PrimaryButton(
                title: 'Schedule',
                onPressed: () => scheduleSheetHandler(context),
              ),
              const SizedBox(height: screenPadding),
            ],
          ),
        ),
      ],
    );
  }
}
