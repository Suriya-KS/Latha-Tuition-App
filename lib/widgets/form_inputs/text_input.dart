import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    required this.labelText,
    required this.prefixIcon,
    required this.inputType,
    this.prefixText,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final TextInputType inputType;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        prefixText: prefixText ?? '',
        prefixIconColor: Theme.of(context).colorScheme.primary,
        label: Text(labelText),
      ),
    );
  }
}
