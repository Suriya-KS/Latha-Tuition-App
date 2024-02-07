import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  const DropdownInput({
    required this.labelText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final List<String> items;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: Theme.of(context).colorScheme.primary,
      ),
      onChanged: onChanged,
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
    );
  }
}
