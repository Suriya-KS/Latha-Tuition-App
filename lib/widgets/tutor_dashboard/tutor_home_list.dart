import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class TutorHomeList extends ConsumerWidget {
  const TutorHomeList({
    required this.loadUpcomingClasses,
    required this.loadScheduledTests,
    super.key,
  });

  final Future<void> Function(BuildContext) loadUpcomingClasses;
  final Future<void> Function(BuildContext) loadScheduledTests;

  void deleteUpcomingClassHandler(
    BuildContext context,
    WidgetRef ref,
    String upcomingClassID,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await firestore
          .collection('upcomingClasses')
          .doc(upcomingClassID)
          .delete();

      if (!context.mounted) throw Error();

      await loadUpcomingClasses(context);

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

  void deleteScheduledTestsHandler(
    BuildContext context,
    WidgetRef ref,
    String scheduledTestID,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await firestore
          .collection('scheduledTests')
          .doc(scheduledTestID)
          .delete();

      if (!context.mounted) throw Error();

      await loadScheduledTests(context);

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
                title: upcomingClasses[index]['batchName'],
                avatarText: formatShortenDay(upcomingClasses[index]['date']),
                icon: Icons.delete_outline,
                iconOnTap: () => deleteUpcomingClassHandler(
                  context,
                  ref,
                  upcomingClasses[index]['id'],
                ),
                children: [
                  Text(
                    formatDate(upcomingClasses[index]['date']),
                    style: const TextStyle(fontSize: 13),
                  ),
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
                  icon: Icons.delete_outline,
                  iconOnTap: () => deleteScheduledTestsHandler(
                    context,
                    ref,
                    scheduledTests[index]['id'],
                  ),
                  children: [
                    Text(
                      scheduledTests[index]['batchName'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
