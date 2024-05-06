import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/widgets/utilities/percent_indicator.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class StudentTestMarksList extends StatelessWidget {
  const StudentTestMarksList({
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
          title: items[index]['name'],
          action: PercentIndicator(
            currentValue: items[index]['marks'],
            totalValue: items[index]['totalMarks'],
          ),
          children: [
            Text(
              formatDateDay(items[index]['date']),
              style: const TextStyle(fontSize: 13),
            ),
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
