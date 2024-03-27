import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedBottomNavigationBar extends StatelessWidget {
  const CurvedBottomNavigationBar({
    required this.index,
    required this.onTap,
    required this.items,
    super.key,
  });

  final int index;
  final void Function(int) onTap;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      onTap: onTap,
      items: items,
    );
  }
}
