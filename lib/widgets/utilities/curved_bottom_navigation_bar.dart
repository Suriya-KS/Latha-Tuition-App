import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';

class CurvedBottomNavigationBar extends ConsumerWidget {
  const CurvedBottomNavigationBar({
    required this.index,
    required this.onTap,
    required this.items,
    super.key,
  });

  final int index;
  final void Function(int) onTap;
  final List<Widget> items;

  void navigationItemTapHandler(WidgetRef ref, int index) {
    ref.read(animatedDrawerProvider.notifier).closeAnimatedDrawer();

    onTap(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CurvedNavigationBar(
      index: index,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      onTap: (index) => navigationItemTapHandler(
        ref,
        index,
      ),
      items: items,
    );
  }
}
