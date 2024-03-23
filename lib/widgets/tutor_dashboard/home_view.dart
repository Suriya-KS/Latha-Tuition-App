import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/home_contents.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  int studentAdmissionRequestCount = 0;

  void loadStudentAdmissionRequestCount(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final studentAdmissionRequestsAggregateQuerySnapshot = await firestore
          .collection('studentAdmissionRequests')
          .where('awaitingApproval', isEqualTo: true)
          .count()
          .get();

      setState(() {
        isLoading = false;
        studentAdmissionRequestCount =
            studentAdmissionRequestsAggregateQuerySnapshot.count ?? 0;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void studentAdmissionRequestsHandler(BuildContext context) async {
    await navigateToStudentApprovalScreen(context);

    if (!context.mounted) return;

    loadStudentAdmissionRequestCount(context);
  }

  @override
  void initState() {
    super.initState();

    loadStudentAdmissionRequestCount(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingFromProvider = ref.watch(loadingProvider);
    final animatedDrawerData = ref.watch(animatedDrawerProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return LoadingOverlay(
      isLoading: isLoading || isLoadingFromProvider,
      child: Stack(
        children: [
          const SideDrawer(),
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
                    title: formatName('Tutor Name'),
                    screenHeight: screenHeight,
                    actions: [
                      IconWithBadgeButton(
                        icon: Icons.person_outline,
                        badgeCount: studentAdmissionRequestCount,
                        onPressed: () => studentAdmissionRequestsHandler(
                          context,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconWithBadgeButton(
                        icon: Icons.currency_rupee,
                        badgeCount: dummyStudentPaymentHistory.length,
                        onPressed: () => navigateToPaymentApprovalScreen(
                          context,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ]),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) => const HomeContents(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
