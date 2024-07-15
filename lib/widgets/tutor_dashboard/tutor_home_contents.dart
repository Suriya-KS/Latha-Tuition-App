import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_home_list.dart';

class TutorHomeContents extends ConsumerStatefulWidget {
  const TutorHomeContents({super.key});

  @override
  ConsumerState<TutorHomeContents> createState() => _TutorHomeContentsState();
}

class _TutorHomeContentsState extends ConsumerState<TutorHomeContents> {
  List<Map<String, dynamic>> items = dummyScheduledTests;

  @override
  Widget build(BuildContext context) {
    final activeToggle = ref.watch(homeViewProvider)[HomeView.activeToggle];

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
                onToggle:
                    ref.read(homeViewProvider.notifier).changeActiveToggle,
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
              : TutorHomeList(items: items),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
