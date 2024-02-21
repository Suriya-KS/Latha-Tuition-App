import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/utilities/calendar.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/track_record_sheet.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/events_summary.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            Calendar(),
            SizedBox(height: 20),
            EventsSummary(),
          ],
        ),
        FloatingCircularActionButton(
          icon: Icons.add,
          onPressed: () => modalBottomSheet(
            context,
            const TrackRecordSheet(),
          ),
        ),
      ],
    );
  }
}
