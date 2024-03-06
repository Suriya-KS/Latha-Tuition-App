import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    required this.labelText,
    required this.prefixIcon,
    required this.inputType,
    this.prefixText,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.initialValue,
    this.obscureText = false,
    this.controller,
    this.validator,
    super.key,
  });

  final String labelText;
  final IconData prefixIcon;
  final TextInputType inputType;
  final String? prefixText;
  final IconData? suffixIcon;
  final void Function()? suffixIconOnPressed;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      controller!.text = initialValue ?? '';
    }

    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(labelText),
        prefixText: prefixText ?? '',
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixIconOnPressed ?? () {},
              )
            : null,
        prefixIconColor: Theme.of(context).colorScheme.primary,
        errorMaxLines: 3,
      ),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: validator,
    );
  }
}
