import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedBottomNavigationBar extends StatelessWidget {
  const CurvedBottomNavigationBar({
    required this.index,
    required this.onTap,
    super.key,
  });

  final int index;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      onTap: onTap,
      items: const [
        Icon(
          Icons.home_outlined,
          color: Colors.white,
          size: 30,
        ),
        Icon(
          Icons.calendar_month_outlined,
          color: Colors.white,
          size: 30,
        ),
        Icon(
          Icons.person_outline,
          color: Colors.white,
          size: 30,
        ),
      ],
    );
  }
}
