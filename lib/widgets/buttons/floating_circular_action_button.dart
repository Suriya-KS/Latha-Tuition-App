import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class FloatingCircularActionButton extends StatelessWidget {
  const FloatingCircularActionButton({
    required this.icon,
    required this.onPressed,
    this.padding,
    super.key,
  });

  final IconData icon;
  final void Function() onPressed;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: padding ?? screenPadding,
      right: padding ?? screenPadding,
      child: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
