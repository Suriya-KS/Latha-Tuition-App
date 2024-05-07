import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_configure_batches.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/utilities/calendar.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_track_record_sheet.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_events_list.dart';

class TutorEventsView extends ConsumerStatefulWidget {
  const TutorEventsView({super.key});

  @override
  ConsumerState<TutorEventsView> createState() => _TutorEventsViewState();
}

class _TutorEventsViewState extends ConsumerState<TutorEventsView> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  List<Map<String, dynamic>> items = [];

  late List<bool> isSelected;

  void loadAttendanceSummary(BuildContext context) async {
    setState(() {
      isLoading = true;
      items = [];
    });

    final selectedDate =
        ref.read(calendarViewProvider)[CalendarView.selectedDate];

    try {
      final attendanceQuerySnapshot = await firestore
          .collection('attendance')
          .where('date', isEqualTo: selectedDate)
          .orderBy('startTime')
          .get();

      final attendanceSummary = attendanceQuerySnapshot.docs
          .map((attendanceQueryDocumentSnapshot) => {
                'id': attendanceQueryDocumentSnapshot.id,
                'batchName': attendanceQueryDocumentSnapshot.data()['batch'],
                'date': attendanceQueryDocumentSnapshot.data()['date'].toDate(),
                'startTime': timestampToTimeOfDay(
                  attendanceQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  attendanceQueryDocumentSnapshot.data()['endTime'],
                ),
                'attendance':
                    attendanceQueryDocumentSnapshot.data()['attendance'],
              })
          .toList();

      setState(() {
        isLoading = false;
        items = attendanceSummary;
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

  void loadTestMarksSummary(BuildContext context) async {
    setState(() {
      isLoading = true;
      items = [];
    });

    final selectedDate =
        ref.read(calendarViewProvider)[CalendarView.selectedDate];

    try {
      final testMarksQuerySnapshot = await firestore
          .collection('testMarks')
          .where('date', isEqualTo: selectedDate)
          .orderBy('startTime')
          .get();

      final testMarksSummary = testMarksQuerySnapshot.docs
          .map((testMarksQueryDocumentSnapshot) => {
                'id': testMarksQueryDocumentSnapshot.id,
                'batchName': testMarksQueryDocumentSnapshot.data()['batch'],
                'date': testMarksQueryDocumentSnapshot.data()['date'].toDate(),
                'startTime': timestampToTimeOfDay(
                  testMarksQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  testMarksQueryDocumentSnapshot.data()['endTime'],
                ),
                'name': testMarksQueryDocumentSnapshot.data()['name'],
                'marks': testMarksQueryDocumentSnapshot.data()['marks'],
                'totalMarks':
                    testMarksQueryDocumentSnapshot.data()['totalMarks'],
              })
          .toList();

      setState(() {
        isLoading = false;
        items = testMarksSummary;
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

  void toggleTrackedRecordsHandler(int index) {
    ref.read(calendarViewProvider.notifier).changeActiveToggle(index);

    setState(() {
      if (index == 0) loadAttendanceSummary(context);
      if (index == 1) loadTestMarksSummary(context);
    });
  }

  void showTrackRecordsSheet(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    ref.read(trackSheetProvider.notifier).setIsBatchNameEditable(true);

    try {
      final settingsDocumentSnapshot = await firestore
          .collection('settings')
          .doc('studentRegistration')
          .get();

      setState(() {
        isLoading = false;
      });

      if (!settingsDocumentSnapshot.exists && context.mounted) {
        return snackBar(
          context,
          content: const Text("No batches found"),
          actionLabel: 'Create now',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TutorConfigureBatchesScreen(),
            ),
          ),
        );
      }

      final settings = settingsDocumentSnapshot.data()!;

      if (!settings.containsKey('batchNames')) return;

      ref.read(trackSheetProvider.notifier).loadBatches(
            List<String>.from(settings['batchNames']),
          );

      if (!context.mounted) return;

      final activeToggle =
          ref.read(calendarViewProvider)[CalendarView.activeToggle];

      modalBottomSheet(
        context,
        TutorTrackRecordSheet(
          onUpdate: () => activeToggle == CalendarViewToggles.attendance
              ? loadAttendanceSummary(context)
              : loadTestMarksSummary(context),
        ),
      );
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

    final activeToggle =
        ref.read(calendarViewProvider)[CalendarView.activeToggle];

    if (activeToggle == CalendarViewToggles.attendance) {
      isSelected = [true, false];

      loadAttendanceSummary(context);
    }

    if (activeToggle == CalendarViewToggles.tests) {
      isSelected = [false, true];

      loadTestMarksSummary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeToggle =
        ref.watch(calendarViewProvider)[CalendarView.activeToggle];

    return LoadingOverlay(
      isLoading: isLoading,
      child: Stack(
        children: [
          Column(
            children: [
              TextAppBar(
                title: activeToggle == CalendarViewToggles.attendance
                    ? 'Attendance Records'
                    : 'Test Marks Records',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Calendar(
                        onDateChange:
                            activeToggle == CalendarViewToggles.attendance
                                ? () => loadAttendanceSummary(context)
                                : () => loadTestMarksSummary(context),
                      ),
                      const SizedBox(height: 20),
                      ToggleInput(
                        isSelected: isSelected,
                        onToggle: toggleTrackedRecordsHandler,
                        children: const [
                          Icon(Icons.groups_outlined),
                          Icon(Icons.assignment_outlined),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (items.isEmpty) const SizedBox(height: 30),
                      items.isEmpty
                          ? ImageWithCaption(
                              imagePath: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? notFoundImage
                                  : notFoundImageDark,
                              description: 'No records found!',
                            )
                          : TutorEventsList(
                              items: items,
                              onUpdate:
                                  activeToggle == CalendarViewToggles.attendance
                                      ? () => loadAttendanceSummary(context)
                                      : () => loadTestMarksSummary(context),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FloatingCircularActionButton(
            icon: Icons.add,
            onPressed: () => showTrackRecordsSheet(context),
          ),
        ],
      ),
    );
  }
}
