import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/screens/student/student_payment_requests.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_home_contents.dart';

class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  void navigateToStudentPaymentRequestsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentPaymentRequestsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animatedDrawerData = ref.watch(animatedDrawerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedName = formatName('Student Name');

    return Stack(
      children: [
        SideDrawer(title: formattedName),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              animatedDrawerData[AnimatedDrawer.isOpen] ? 30 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 10,
                blurRadius: 30,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: animatedDrawerData[AnimatedDrawer.isOpen]
              ? Clip.hardEdge
              : Clip.none,
          transform: Matrix4.translationValues(
            animatedDrawerData[AnimatedDrawer.xOffset],
            animatedDrawerData[AnimatedDrawer.yOffset],
            0,
          )
            ..scale(animatedDrawerData[AnimatedDrawer.scale])
            ..rotateZ(animatedDrawerData[AnimatedDrawer.rotateZ]),
          child: CustomScrollView(
            slivers: [
              ScrollableImageAppBar(
                title: formattedName,
                screenHeight: screenHeight,
                actions: [
                  IconWithBadgeButton(
                    icon: Icons.currency_rupee,
                    showBadgeMark: true,
                    onPressed: () => navigateToStudentPaymentRequestsScreen(
                      context,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => const StudentHomeContents(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
