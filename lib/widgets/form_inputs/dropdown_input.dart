import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  const DropdownInput({
    required this.labelText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    required this.validator,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: Theme.of(context).colorScheme.primary,
      ),
      items: items.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Column(
            children: [
              Text(value),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
