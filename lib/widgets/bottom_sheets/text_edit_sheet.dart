import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class TextEditSheet extends StatefulWidget {
  const TextEditSheet({
    required this.title,
    required this.fieldName,
    required this.buttonText,
    required this.onPressed,
    this.inputType,
    this.initialValue,
    super.key,
  });

  final String title;
  final String fieldName;
  final String buttonText;
  final void Function(String) onPressed;
  final TextInputType? inputType;
  final String? initialValue;

  @override
  State<TextEditSheet> createState() => _TextEditSheetState();
}

class _TextEditSheetState extends State<TextEditSheet> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController controller;

  String getConnector(String value) {
    List<String> vowels = ['a', 'e', 'i', 'o', 'u'];
    String firstCharacter = value.toLowerCase()[0];

    return vowels.contains(firstCharacter) ? 'an' : 'a';
  }

  submitHandler() {
    if (formKey.currentState!.validate()) {
      widget.onPressed(controller.text);
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(title: widget.title),
        const SizedBox(height: 30),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextInput(
                labelText: capitalizeText(widget.fieldName),
                prefixIcon: Icons.assignment_outlined,
                inputType: widget.inputType != null
                    ? widget.inputType!
                    : TextInputType.text,
                initialValue: widget.initialValue,
                controller: controller,
                validator: (value) => validateUpdateText(
                  value,
                  widget.initialValue,
                  getConnector(widget.fieldName),
                  widget.fieldName,
                ),
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                title: widget.buttonText,
                onPressed: submitHandler,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
