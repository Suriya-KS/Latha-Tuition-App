import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentHomeContents extends StatelessWidget {
  const StudentHomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Column(
        children: [
          const Text('Upcoming Classes'),
          const SizedBox(height: 10),
          for (int i = 0; i < 2; i++)
            TextAvatarActionCard(
              title: formatDate(dummyUpcomingClasses[i]['date']),
              avatarText: formatShortenDay(dummyScheduledTests[i]['date']),
              children: [
                Text(
                  formatTimeRange(
                    dummyUpcomingClasses[i]['startTime'],
                    dummyUpcomingClasses[i]['endTime'],
                  ),
                ),
              ],
            ),
          const SizedBox(height: screenPadding),
          const Text('Scheduled Tests'),
          const SizedBox(height: 10),
          for (int i = 0; i < 2; i++)
            TextAvatarActionCard(
              title: dummyScheduledTests[i]['testName'],
              avatarText: formatShortenDay(dummyScheduledTests[i]['date']),
              children: [
                Text(formatDate(dummyScheduledTests[i]['date'])),
                Text(
                  formatTimeRange(
                    dummyScheduledTests[i]['startTime'],
                    dummyScheduledTests[i]['endTime'],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
