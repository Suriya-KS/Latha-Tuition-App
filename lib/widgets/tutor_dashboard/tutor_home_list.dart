import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';

class TutorHomeList extends ConsumerWidget {
  const TutorHomeList({
    required this.items,
    super.key,
  });

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeToggle = ref.watch(homeViewProvider)[HomeView.activeToggle];

    Widget content = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length + 1,
      itemBuilder: (context, index) => index < items.length
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextAvatarActionCard(
                title: items[index]['batchName'],
                avatarText: formatShortenDay(items[index]['date']),
                icon: Icons.delete_outline,
                iconOnTap: () {},
                children: [
                  Text(
                    formatDate(items[index]['date']),
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
            )
          : const SizedBox(height: 80),
    );

    if (activeToggle == HomeViewToggles.tests) {
      content = ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (context, index) => index < items.length
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextAvatarActionCard(
                  title: items[index]['testName'],
                  avatarText: formatShortenDay(items[index]['date']),
                  icon: Icons.delete_outline,
                  iconOnTap: () {},
                  children: [
                    Text(
                      items[index]['batchName'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatDate(items[index]['date']),
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
              )
            : const SizedBox(height: 80),
      );
    }

    return content;
  }
}
