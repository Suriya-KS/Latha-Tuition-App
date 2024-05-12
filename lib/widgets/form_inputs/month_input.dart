import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class MonthInput extends StatefulWidget {
  const MonthInput({
    required this.onChange,
    this.yearRange = 2,
    super.key,
  });

  final void Function(DateTime) onChange;
  final int yearRange;

  @override
  State<MonthInput> createState() => _MonthInputState();
}

class _MonthInputState extends State<MonthInput> {
  DateTime selectedDate = DateTime.now();

  late Duration twoYearsDuration;

  bool get canNavigateBack =>
      DateTime(selectedDate.year, selectedDate.month - 1, 1)
          .isAfter(DateTime.now().subtract(twoYearsDuration));

  bool get canNavigateForward =>
      DateTime(selectedDate.year, selectedDate.month + 1, 1)
          .isBefore(DateTime.now().add(twoYearsDuration));

  void navigateToPreviousMonth() {
    final newDate = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      1,
    );

    if (!canNavigateBack) return;

    setState(() {
      selectedDate = newDate;
    });

    widget.onChange(selectedDate);
  }

  void navigateToNextMonth() {
    final newDate = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      1,
    );

    if (!canNavigateForward) return;

    setState(() {
      selectedDate = newDate;
    });

    widget.onChange(selectedDate);
  }

  @override
  void initState() {
    super.initState();

    twoYearsDuration = Duration(days: 365 * widget.yearRange);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM yyyy').format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 16,
          ),
          onPressed: canNavigateBack ? navigateToPreviousMonth : null,
        ),
        SubtitleText(subtitle: formattedDate),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
          onPressed: canNavigateForward ? navigateToNextMonth : null,
        ),
      ],
    );
  }
}
