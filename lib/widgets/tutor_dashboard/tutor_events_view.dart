import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
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
  late List<Map<String, dynamic>> items;
  late List<bool> isSelected;

  void toggleTrackedRecordsHandler(int index) {
    ref.read(calendarViewProvider.notifier).changeActiveToggle(index);

    setState(() {
      if (index == 0) items = dummyAttendanceData;
      if (index == 1) items = dummyTestMarksData;
    });
  }

  @override
  void initState() {
    super.initState();

    final activeToggle =
        ref.read(calendarViewProvider)[CalendarView.activeToggle];

    items = dummyAttendanceData;
    isSelected = [true, false];

    if (activeToggle == CalendarViewToggles.tests) {
      items = dummyTestMarksData;
      isSelected = [false, true];
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeToggle =
        ref.watch(calendarViewProvider)[CalendarView.activeToggle];

    return Stack(
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
                    const Calendar(),
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
                    items.isEmpty
                        ? Column(
                            children: [
                              const SizedBox(height: 30),
                              SvgPicture.asset(
                                notFoundImage,
                                height: 100,
                              ),
                              const SizedBox(height: 20),
                              const Text('No Records Found!'),
                            ],
                          )
                        : TutorEventsList(items: items),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        FloatingCircularActionButton(
          icon: Icons.add,
          onPressed: () => modalBottomSheet(
            context,
            const TutorTrackRecordSheet(),
          ),
        ),
      ],
    );
  }
}
