import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';

class ScrollableImageAppBar extends ConsumerWidget {
  const ScrollableImageAppBar({
    required this.title,
    required this.screenHeight,
    this.actions,
    super.key,
  });

  final String title;
  final double screenHeight;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDrawerOpen =
        ref.watch(animatedDrawerProvider)[AnimatedDrawer.isOpen];

    return SliverAppBar(
      expandedHeight: screenHeight * 0.30,
      pinned: true,
      actions: [
        const SizedBox(width: 15),
        IconWithBadgeButton(
          icon: !isDrawerOpen ? Icons.menu_outlined : Icons.arrow_back_outlined,
          onPressed:
              ref.read(animatedDrawerProvider.notifier).toggleAnimatedDrawer,
        ),
        const Spacer(),
        if (actions != null) ...actions!,
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        background: Stack(
          children: [
            SvgPicture.asset(
              Theme.of(context).brightness == Brightness.light
                  ? classRoomImage
                  : classRoomImageDark,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            )
          ],
        ),
      ),
    );
  }
}
