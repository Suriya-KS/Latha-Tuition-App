import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentHomeList extends ConsumerWidget {
  const StudentHomeList({
    required this.loadUpcomingClasses,
    required this.loadScheduledTests,
    super.key,
  });

  final Future<void> Function(BuildContext) loadUpcomingClasses;
  final Future<void> Function(BuildContext) loadScheduledTests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewData = ref.watch(homeViewProvider);
    final upcomingClasses = homeViewData[HomeView.upcomingClasses];
    final scheduledTests = homeViewData[HomeView.scheduledTests];

    Widget content = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: upcomingClasses.length + 1,
      itemBuilder: (context, index) => index < upcomingClasses.length
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextAvatarActionCard(
                title: formatDate(upcomingClasses[index]['date']),
                avatarText: formatShortenDay(upcomingClasses[index]['date']),
                children: [
                  Text(
                    formatTimeRange(
                      upcomingClasses[index]['startTime'],
                      upcomingClasses[index]['endTime'],
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            )
          : const SizedBox(height: 80),
    );

    if (homeViewData[HomeView.activeToggle] == HomeViewToggles.tests) {
      content = ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scheduledTests.length + 1,
        itemBuilder: (context, index) => index < scheduledTests.length
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextAvatarActionCard(
                  title: scheduledTests[index]['testName'],
                  avatarText: formatShortenDay(scheduledTests[index]['date']),
                  children: [
                    Text(
                      formatDate(scheduledTests[index]['date']),
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      formatTimeRange(
                        scheduledTests[index]['startTime'],
                        scheduledTests[index]['endTime'],
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
            : const SizedBox(height: 80),
      );
    }

    return content;
  }
}
