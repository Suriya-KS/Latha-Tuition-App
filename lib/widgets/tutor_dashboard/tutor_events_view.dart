import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/utilities/calendar.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_track_record_sheet.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_events_summary.dart';

class TutorEventsView extends StatelessWidget {
  const TutorEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const Column(
            children: [
              Calendar(),
              SizedBox(height: 20),
              TutorEventsSummary(),
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
      ),
    );
  }
}
