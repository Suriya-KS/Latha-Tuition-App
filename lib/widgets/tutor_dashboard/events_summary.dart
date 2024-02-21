import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/events_list.dart';

class EventsSummary extends ConsumerStatefulWidget {
  const EventsSummary({super.key});

  @override
  ConsumerState<EventsSummary> createState() => _EventsSummaryState();
}

class _EventsSummaryState extends ConsumerState<EventsSummary> {
  final GlobalKey columnKey = GlobalKey();

  late List<Map<String, dynamic>> items;
  late List<bool> isSelected;

  void toggleHandler(int index) {
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
    double columnHeight = 200;

    if (columnKey.currentContext != null) {
      RenderBox renderBox =
          columnKey.currentContext!.findRenderObject() as RenderBox;
      columnHeight = renderBox.size.height;
    }

    return Expanded(
      child: Column(
        key: columnKey,
        children: [
          ToggleInput(
            labelTextLeft: 'Attendance',
            labelTextRight: 'Tests',
            iconLeft: Icons.groups_outlined,
            iconRight: Icons.assignment_outlined,
            isSelected: isSelected,
            onToggle: toggleHandler,
          ),
          const SizedBox(height: 20),
          items.isEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 30),
                    SvgPicture.asset(
                      notFoundImage,
                      height: columnHeight * 0.35,
                    ),
                    const SizedBox(height: 20),
                    const Text('No Records Found!'),
                  ],
                )
              : EventsList(items: items),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
