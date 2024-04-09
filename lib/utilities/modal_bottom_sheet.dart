import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

Future<dynamic> modalBottomSheet(BuildContext context, Widget content) async {
  final screenWidth = MediaQuery.of(context).size.width;

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 15,
          right: screenPadding,
          bottom: screenPadding + MediaQuery.of(context).viewInsets.bottom,
          left: screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth * 0.12,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(
                      0.3,
                    ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    ),
  );
}
