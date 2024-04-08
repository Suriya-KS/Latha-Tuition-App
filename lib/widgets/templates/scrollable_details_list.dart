import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';

class ScrollableDetailsList extends StatelessWidget {
  const ScrollableDetailsList({
    required this.title,
    required this.onPressed,
    required this.children,
    super.key,
  });

  final String title;
  final void Function()? onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar(title: title),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  ...children,
                ],
              ),
              if (onPressed != null)
                FloatingCircularActionButton(
                  icon: Icons.check,
                  padding: 20,
                  onPressed: onPressed!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
