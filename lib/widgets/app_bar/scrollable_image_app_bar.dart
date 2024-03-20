import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';

class ScrollableImageAppBar extends ConsumerWidget {
  const ScrollableImageAppBar({
    required this.title,
    required this.screenHeight,
    super.key,
  });

  final String title;
  final double screenHeight;

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
        IconWithBadgeButton(
          icon: Icons.person_outline,
          badgeCount: dummyStudentApprovals.length,
          onPressed: () => navigateToStudentApprovalScreen(context),
        ),
        const SizedBox(width: 10),
        IconWithBadgeButton(
          icon: Icons.currency_rupee,
          badgeCount: dummyStudentPaymentHistory.length,
          onPressed: () => navigateToPaymentApprovalScreen(context),
        ),
        const SizedBox(width: 20),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        background: SvgPicture.asset(
          placeholderImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
