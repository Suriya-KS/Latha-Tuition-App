import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/attendance_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/cards/title_input_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/label_toggle_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';

class AttendanceRecordsView extends ConsumerWidget {
  const AttendanceRecordsView({super.key});

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
                        ? TitleInputCard(
                            title: formatDate(attendanceList[index]['date']),
                            description: attendanceList[index]['time'],
                            input: LabelToggleInput(
                              iconLeft: Icons.check,
                              iconRight: Icons.close,
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
                            ),
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
