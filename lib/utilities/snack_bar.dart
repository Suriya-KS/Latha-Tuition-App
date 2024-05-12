import 'package:flutter/material.dart';

Future<void> snackBar(
  BuildContext context, {
  required Widget content,
  String? actionLabel,
  void Function()? onPressed,
}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  SnackBar snackBar = SnackBar(
    content: content,
    action: actionLabel != null && onPressed != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onPressed,
          )
        : null,
  );

  await ScaffoldMessenger.of(context).showSnackBar(snackBar).closed;
}
