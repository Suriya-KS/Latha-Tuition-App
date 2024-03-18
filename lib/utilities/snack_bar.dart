import 'package:flutter/material.dart';

void snackBar(
  BuildContext context, {
  required Widget content,
  String? actionLabel,
  void Function()? onPressed,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  SnackBar snackBar = SnackBar(
    content: content,
    action: actionLabel != null && onPressed != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onPressed,
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
