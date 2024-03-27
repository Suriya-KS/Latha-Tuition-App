import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/text_avatar_action_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class TutorStudentAttendanceRecordsView extends ConsumerWidget {
  const TutorStudentAttendanceRecordsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<dynamic> attendanceList = ref.watch(attendanceProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Stack(
          children: [
            Column(
              children: [
                MonthInput(
                  onChange: (date) {},
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: attendanceList.length + 1,
                    itemBuilder: (context, index) => index <
                            attendanceList.length
                        ? TextAvatarActionCard(
                            title: formatDate(attendanceList[index]['date']),
                            action: ToggleInput(
                              backgroundColors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.error,
                              ],
                              isSelected: attendanceList[index]
                                          ['attendanceStatus'] ==
                                      'present'
                                  ? [true, false]
                                  : [false, true],
                              onToggle: (toggleIndex) =>
                                  attendanceStatusToggleHandler(
                                toggleIndex,
                                index,
                                ref,
                              ),
                              children: const [
                                Icon(Icons.check),
                                Icon(Icons.close),
                              ],
                            ),
                            children: [Text(attendanceList[index]['time'])],
                          )
                        : const SizedBox(height: 120),
                  ),
                ),
              ],
            ),
            FloatingCircularActionButton(
              icon: Icons.check_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
