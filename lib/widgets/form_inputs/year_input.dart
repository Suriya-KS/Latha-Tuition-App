import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class YearInput extends StatefulWidget {
  const YearInput({
    required this.onChange,
    this.yearRange = 2,
    super.key,
  });

  final void Function(int) onChange;
  final int yearRange;

  @override
  State<YearInput> createState() => _YearInputState();
}

class _YearInputState extends State<YearInput> {
  int selectedYear = DateTime.now().year;

  bool get canNavigateBack =>
      selectedYear - 1 >= DateTime.now().year - widget.yearRange;

  bool get canNavigateForward =>
      selectedYear + 1 <= DateTime.now().year + widget.yearRange;

  void navigateToPreviousYear() {
    if (!canNavigateBack) return;

    setState(() {
      selectedYear--;
    });

    widget.onChange(selectedYear);
  }

  void navigateToNextYear() {
    if (!canNavigateForward) return;

    setState(() {
      selectedYear++;
    });

    widget.onChange(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 16,
          ),
          onPressed: canNavigateBack ? navigateToPreviousYear : null,
        ),
        SubtitleText(subtitle: selectedYear.toString()),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
          onPressed: canNavigateForward ? navigateToNextYear : null,
        ),
      ],
    );
  }
}
