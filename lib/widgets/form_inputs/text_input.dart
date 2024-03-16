import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    required this.labelText,
    required this.prefixIcon,
    required this.inputType,
    this.prefixText,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.initialValue,
    this.obscureText = false,
    this.readOnly = false,
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
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.text = widget.initialValue ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        prefixText: widget.prefixText ?? '',
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon),
                onPressed: widget.suffixIconOnPressed ?? () {},
              )
            : null,
        prefixIconColor: Theme.of(context).colorScheme.primary,
        errorMaxLines: 3,
      ),
      obscureText: widget.obscureText,
      minLines: 1,
      maxLines: widget.inputType == TextInputType.multiline ? 5 : 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: widget.readOnly,
      controller: widget.controller,
      validator: widget.validator,
    );
  }
}
