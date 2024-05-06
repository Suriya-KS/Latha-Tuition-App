import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/utilities/avatar_text.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentAttendanceList extends StatelessWidget {
  const StudentAttendanceList({
    required this.items,
    super.key,
  });

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => TextAvatarActionCard(
          title: formatDate(items[index]['date']),
          avatarText: formatShortenDay(items[index]['date']),
          action: items[index]['status'] == 'present'
              ? AvatarText(
                  'P',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                )
              : AvatarText(
                  'A',
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
          children: [
            Text(
              formatTimeRange(
                items[index]['startTime'],
                items[index]['endTime'],
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
