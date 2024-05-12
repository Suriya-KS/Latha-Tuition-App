import 'package:flutter/material.dart';

class TimeInput extends StatelessWidget {
  const TimeInput({
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.initialTime,
    this.validator,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TimeOfDay? initialTime;
  final String? Function(String?)? validator;

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final hours = (hour == 0 ? 12 : hour).toString().padLeft(2, '0');
    final minutes = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';

    return '$hours:$minutes $period';
  }

  void tapHandler(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    controller.value = TextEditingValue(
      text: formatTimeOfDay(pickedTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.none,
      showCursor: false,
      decoration: InputDecoration(
        label: Text(labelText),
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: Theme.of(context).colorScheme.primary,
        errorMaxLines: 2,
      ),
      onTap: () => tapHandler(context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: validator,
    );
  }
}
