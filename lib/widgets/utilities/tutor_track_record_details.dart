import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/track_sheet_provider.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_track_record_sheet.dart';

class TutorTrackRecordDetails extends ConsumerWidget {
  const TutorTrackRecordDetails({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.screen,
    this.description,
    this.totalMarks,
    this.onEdit,
    super.key,
  });

  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Screen screen;
  final String? description;
  final double? totalMarks;
  final void Function()? onEdit;

  String? get formattedTotalMarks {
    if (totalMarks != null) {
      return totalMarks!.truncateToDouble() == totalMarks
          ? totalMarks!.toStringAsFixed(0)
          : totalMarks!.toStringAsFixed(2);
    } else {
      return null;
    }
  }

  Future<void> loadBatches(BuildContext context, WidgetRef ref) async {
    final firestore = FirebaseFirestore.instance;
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      final settingsDocumentSnapshot = await firestore
          .collection('settings')
          .doc('studentRegistration')
          .get();

      loadingMethods.setLoadingStatus(false);

      if (!settingsDocumentSnapshot.exists) return;

      final settings = settingsDocumentSnapshot.data()!;

      if (!settings.containsKey('batchNames')) return;

      ref.read(trackSheetProvider.notifier).loadBatches(
            List<String>.from(settings['batchNames']),
          );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void editTrackRecordHandler(BuildContext context, WidgetRef ref) async {
    final batchNames = ref.read(trackSheetProvider)[TrackSheet.batchNames];

    if (batchNames.length == 0) await loadBatches(context, ref);

    if (screen == Screen.attendance) {
      ref.read(trackSheetProvider.notifier).changeActiveToggle(0);
    }

    if (screen == Screen.testMarks) {
      ref.read(trackSheetProvider.notifier).changeActiveToggle(1);
    }

    if (!context.mounted) return;

    await modalBottomSheet(
      context,
      TutorTrackRecordSheet(
        screen: screen,
      ),
    );

    if (onEdit != null) onEdit!();
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
            onPressed: () => editTrackRecordHandler(context, ref),
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
