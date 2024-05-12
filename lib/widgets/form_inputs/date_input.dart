import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';

class DateInput extends StatefulWidget {
  const DateInput({
    required this.labelText,
    required this.prefixIcon,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.controller,
    this.validator,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late DateTime initialDate;

  void tapHandler() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate == null) return;

    setState(() => initialDate = pickedDate);

    widget.controller.text = formatDate(pickedDate);
  }

  @override
  void initState() {
    super.initState();

    initialDate = widget.initialDate;
    widget.controller.text = formatDate(initialDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: Theme.of(context).colorScheme.primary,
      ),
      showCursor: false,
      onTap: tapHandler,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: widget.validator,
    );
  }
}
