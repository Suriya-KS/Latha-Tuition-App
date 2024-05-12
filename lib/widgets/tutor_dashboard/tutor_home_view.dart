import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_home_contents.dart';

class TutorHomeView extends ConsumerStatefulWidget {
  const TutorHomeView({super.key});

  @override
  ConsumerState<TutorHomeView> createState() => _TutorHomeViewState();
}

class _TutorHomeViewState extends ConsumerState<TutorHomeView> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String tutorName = '';
  int studentAdmissionRequestCount = 0;
  int studentPaymentRequestCount = 0;

  void loadTutorName(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final tutorID = ref.read(authenticationProvider)[Authentication.tutorID];

      final tutorDocumentSnapshot =
          await firestore.collection('tutors').doc(tutorID).get();

      if (!tutorDocumentSnapshot.exists) {
        throw Error();
      }

      setState(() {
        isLoading = false;
        tutorName = tutorDocumentSnapshot.data()!['name'];
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

  void loadStudentPaymentRequestsCount(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final studentPaymentRequestsAggregateQuerySnapshot = await firestore
          .collection('payments')
          .where('status', isEqualTo: 'pending approval')
          .count()
          .get();

      setState(() {
        isLoading = false;
        studentPaymentRequestCount =
            studentPaymentRequestsAggregateQuerySnapshot.count ?? 0;
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
    await navigateToTutorNewAdmissionsScreen(context);

    if (!context.mounted) return;

    loadStudentAdmissionRequestCount(context);
  }

  void studentPaymentRequestsHandler(BuildContext context) async {
    await navigateToTutorPaymentApprovalScreen(context);

    if (!context.mounted) return;

    loadStudentPaymentRequestsCount(context);
  }

  @override
  void initState() {
    super.initState();

    loadTutorName(context);
    loadStudentAdmissionRequestCount(context);
    loadStudentPaymentRequestsCount(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingFromProvider = ref.watch(loadingProvider);
    final animatedDrawerData = ref.watch(animatedDrawerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedName = formatName(tutorName);

    return LoadingOverlay(
      isLoading: isLoading || isLoadingFromProvider,
      child: Stack(
        children: [
          SideDrawer(title: formattedName),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(
                animatedDrawerData[AnimatedDrawer.isOpen] ? 30 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                      icon: Icons.person_outline,
                      badgeCount: studentAdmissionRequestCount,
                      onPressed: () => studentAdmissionRequestsHandler(
                        context,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconWithBadgeButton(
                      icon: Icons.currency_rupee,
                      badgeCount: studentPaymentRequestCount,
                      onPressed: () => studentPaymentRequestsHandler(
                        context,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) => const TutorHomeContents(),
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
