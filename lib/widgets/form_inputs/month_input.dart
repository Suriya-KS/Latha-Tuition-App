import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class MonthInput extends StatefulWidget {
  const MonthInput({
    required this.onChange,
    super.key,
  });

  final void Function(DateTime) onChange;

  @override
  State<MonthInput> createState() => _MonthInputState();
}

class _MonthInputState extends State<MonthInput> {
  DateTime selectedDate = DateTime.now();

  void navigateToPreviousMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month - 1,
        1,
      );
    });

    widget.onChange(selectedDate);
  }

  void navigateToNextMonth() {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        1,
      );
    });

    widget.onChange(selectedDate);
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
          onPressed: navigateToPreviousMonth,
        ),
        SubtitleText(subtitle: formattedDate),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
          onPressed: navigateToNextMonth,
        ),
      ],
    );
  }
}
