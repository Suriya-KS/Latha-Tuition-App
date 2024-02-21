import 'package:flutter/material.dart';

void modalBottomSheet(BuildContext context, Widget content) {
  final screenWidth = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 15,
        right: 30,
        bottom: 30,
        left: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.12,
            height: 6,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
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
  );
}
