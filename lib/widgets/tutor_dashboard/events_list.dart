import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_card.dart';

class EventsList extends ConsumerWidget {
  const EventsList({
    required this.items,
    super.key,
  });

  final List<Map<String, dynamic>> items;

  String formatTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    String startHours = (startTime.hour % 12 == 0 ? 12 : startTime.hour % 12)
        .toString()
        .padLeft(2, '0');
    String startMinutes = startTime.minute.toString().padLeft(2, '0');
    String endHours = (endTime.hour % 12 == 0 ? 12 : endTime.hour % 12)
        .toString()
        .padLeft(2, '0');
    String endMinutes = endTime.minute.toString().padLeft(2, '0');
    String startPeriod = startTime.period == DayPeriod.am ? 'am' : 'pm';
    String endPeriod = endTime.period == DayPeriod.am ? 'am' : 'pm';

    return '$startHours:$startMinutes $startPeriod - $endHours:$endMinutes $endPeriod';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeToggle =
        ref.watch(calendarViewProvider)[CalendarView.activeToggle];

    Widget content = ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => TextAvatarCard(
        title: items[index]['batchName']!,
        avatarText: items[index]['standard']!,
        children: [
          Text(
            formatTimeRange(
              items[index]['startTime'],
              items[index]['endTime'],
            ),
          ),
        ],
      ),
    );

    if (activeToggle == CalendarViewToggles.tests) {
      content = ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => TextAvatarCard(
          title: items[index]['testName'],
          avatarText: items[index]['standard']!,
          children: [
            Text(items[index]['batchName']!),
            Text(
              formatTimeRange(
                items[index]['startTime'],
                items[index]['endTime'],
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: content,
      ),
    );
  }
}
