import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class YearInput extends StatefulWidget {
  const YearInput({
    required this.onChange,
    super.key,
  });

  final void Function(int) onChange;

  @override
  State<YearInput> createState() => _YearInputState();
}

class _YearInputState extends State<YearInput> {
  int selectedYear = DateTime.now().year;

  void navigateToPreviousYear() {
    setState(() {
      selectedYear--;
    });

    widget.onChange(selectedYear);
  }

  void navigateToNextYear() {
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
          onPressed: navigateToPreviousYear,
        ),
        SubtitleText(subtitle: selectedYear.toString()),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
          onPressed: navigateToNextYear,
        ),
      ],
    );
  }
}
