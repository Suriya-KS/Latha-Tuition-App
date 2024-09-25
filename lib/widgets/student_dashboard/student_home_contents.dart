import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_home_list.dart';

class StudentHomeContents extends ConsumerWidget {
  const StudentHomeContents({
    required this.loadUpcomingClasses,
    required this.loadScheduledTests,
    super.key,
  });

  final Future<void> Function(BuildContext) loadUpcomingClasses;
  final Future<void> Function(BuildContext) loadScheduledTests;

  void scheduleToggleHandler(BuildContext context, WidgetRef ref, int index) {
    ref.read(homeViewProvider.notifier).changeActiveToggle(index);

    if (index == 0) loadUpcomingClasses(context);
    if (index == 1) loadScheduledTests(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewData = ref.watch(homeViewProvider);
    final activeToggle = homeViewData[HomeView.activeToggle];

    List<Map<String, dynamic>> items = [];

    if (activeToggle == HomeViewToggles.classes) {
      items = homeViewData[HomeView.upcomingClasses];
    }

    if (activeToggle == HomeViewToggles.tests) {
      items = homeViewData[HomeView.scheduledTests];
    }

    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeToggle == HomeViewToggles.classes
                    ? 'Upcoming Classes'
                    : 'Scheduled Tests',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ToggleInput(
                isSelected: activeToggle == HomeViewToggles.classes
                    ? [true, false]
                    : [false, true],
                onToggle: (index) => scheduleToggleHandler(context, ref, index),
                children: const [
                  Icon(Icons.groups_outlined),
                  Icon(Icons.assignment_outlined),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (items.isEmpty) const SizedBox(height: 30),
          items.isEmpty
              ? ImageWithCaption(
                  imagePath: Theme.of(context).brightness == Brightness.light
                      ? notFoundImage
                      : notFoundImageDark,
                  description: activeToggle == HomeViewToggles.classes
                      ? 'No upcoming classes!'
                      : 'No scheduled tests!',
                  enableBottomPadding: false,
                )
              : StudentHomeList(
                  loadUpcomingClasses: loadUpcomingClasses,
                  loadScheduledTests: loadScheduledTests,
                ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
