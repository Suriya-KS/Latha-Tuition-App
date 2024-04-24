import 'package:flutter/material.dart';

void alertDialogue(
  BuildContext context, {
  required List<Widget> actions,
  String? title,
  String? description,
}) async {
  title ??= 'Unsaved Changes';
  description ??= 'Are you sure to leave? Any unsaved data will be lost';

  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title!),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(description!),
          ],
        ),
      ),
      actions: actions,
    ),
  );
}

void closeAlertDialogue(
  BuildContext context, {
  void Function(BuildContext)? function,
}) {
  Navigator.pop(context);

  if (function == null) return;

  function(context);
}
