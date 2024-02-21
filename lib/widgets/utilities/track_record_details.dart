import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/track_record_sheet.dart';

class TrackRecordDetails extends ConsumerWidget {
  const TrackRecordDetails({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.screen,
    this.description,
    this.totalMarks,
    super.key,
  });

  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Screen screen;
  final String? description;
  final double? totalMarks;

  String? get formattedTotalMarks {
    if (totalMarks != null) {
      return totalMarks!.truncateToDouble() == totalMarks
          ? totalMarks!.toStringAsFixed(0)
          : totalMarks!.toStringAsFixed(2);
    } else {
      return null;
    }
  }

  void editHandler(BuildContext context, WidgetRef ref) {
    if (screen == Screen.attendance) {
      ref.read(trackSheetProvider.notifier).changeActiveToggle(0);
    }

    if (screen == Screen.testMarks) {
      ref.read(trackSheetProvider.notifier).changeActiveToggle(1);
    }

    modalBottomSheet(
      context,
      TrackRecordSheet(
        screen: screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Card(
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: SubtitleText(subtitle: title),
                ),
                const SizedBox(height: 10),
                if (screen == Screen.testMarks && description != null)
                  FractionallySizedBox(
                    widthFactor: 0.85,
                    child: TextWithIcon(
                      icon: Icons.groups_outlined,
                      text: description!,
                    ),
                  ),
                if (screen == Screen.testMarks) const SizedBox(height: 3),
                if (screen == Screen.testMarks)
                  TextWithIcon(
                    icon: Icons.equalizer_outlined,
                    text: 'Total Marks: $formattedTotalMarks',
                  ),
                const SizedBox(height: 3),
                TextWithIcon(
                  icon: Icons.calendar_month_outlined,
                  text: formatDate(date),
                ),
                const SizedBox(height: 3),
                TextWithIcon(
                  icon: Icons.alarm_outlined,
                  text: formatTimeRange(
                    startTime,
                    endTime,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: () => editHandler(context, ref),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}
