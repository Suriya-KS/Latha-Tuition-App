import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class VerificationCodeInput extends StatelessWidget {
  const VerificationCodeInput({
    required this.screenSize,
    this.focusNode,
    required this.controller,
    super.key,
  });

  final MediaQueryData screenSize;
  final FocusNode? focusNode;
  final TextEditingController controller;

  void focusNextInput(BuildContext context, String value) {
    if (value.length == 1) FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = screenSize.size.width;
    final screenPadding = screenSize.padding.left + screenSize.padding.right;
    final inputWidth = (screenWidth - screenPadding) * 0.6 / 4;

    return SizedBox(
      width: inputWidth,
      child: TextFormField(
        style: Theme.of(context).textTheme.titleLarge,
        decoration: InputDecoration(
          filled: true,
          fillColor: primaryBackgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.transparent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2),
          ),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => focusNextInput(context, value),
        focusNode: focusNode,
        controller: controller,
      ),
    );
  }
}
