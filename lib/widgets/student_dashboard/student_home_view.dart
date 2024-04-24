import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/screens/student/student_payment_history.dart';
import 'package:latha_tuition_app/screens/student/student_feedbacks.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_home_contents.dart';

class StudentHomeView extends ConsumerStatefulWidget {
  const StudentHomeView({super.key});

  @override
  ConsumerState<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends ConsumerState<StudentHomeView> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool showPaymentBadgeMark = false;
  bool showFeedbackBadgeMark = false;
  String studentName = '';

  void loadStudentName(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final studentID =
          ref.read(authenticationProvider)[Authentication.studentID];

      final studentDocumentSnapshot =
          await firestore.collection('students').doc(studentID).get();

      if (!studentDocumentSnapshot.exists) throw Error();

      setState(() {
        isLoading = false;
        studentName = studentDocumentSnapshot.data()!['name'];
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

  void loadPaymentHistoryNotification(BuildContext context) async {
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    setState(() {
      isLoading = true;
    });

    try {
      final paymentHistoryNotificationAggregateQuerySnapshot = await firestore
          .collection('payments')
          .where('studentID', isEqualTo: studentID)
          .where('notifyStudent', isEqualTo: true)
          .count()
          .get();

      setState(() {
        isLoading = false;
        showPaymentBadgeMark =
            (paymentHistoryNotificationAggregateQuerySnapshot.count ?? 0) > 0;
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

  void loadFeedbackNotification(BuildContext context) async {
    final studentID =
        ref.read(authenticationProvider)[Authentication.studentID];

    setState(() {
      isLoading = true;
    });

    try {
      final feedbackNotificationAggregateQuerySnapshot = await firestore
          .collection('feedbacks')
          .where('studentID', isEqualTo: studentID)
          .where('notifyStudent', isEqualTo: true)
          .count()
          .get();

      setState(() {
        isLoading = false;
        showFeedbackBadgeMark =
            (feedbackNotificationAggregateQuerySnapshot.count ?? 0) > 0;
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

  void navigateToStudentPaymentHistoryScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentPaymentHistoryScreen(),
      ),
    );

    if (!context.mounted) return;

    loadPaymentHistoryNotification(context);
  }

  void navigateToStudentFeedbacksScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentFeedbacksScreen(),
      ),
    );

    if (!context.mounted) return;

    loadFeedbackNotification(context);
  }

  @override
  void initState() {
    super.initState();

    loadStudentName(context);
    loadPaymentHistoryNotification(context);
    loadFeedbackNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    final animatedDrawerData = ref.watch(animatedDrawerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedName = formatName(studentName);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Stack(
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
                      showBadgeMark: showPaymentBadgeMark,
                      onPressed: () => navigateToStudentPaymentHistoryScreen(
                        context,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconWithBadgeButton(
                      icon: Icons.message_outlined,
                      showBadgeMark: showFeedbackBadgeMark,
                      onPressed: () => navigateToStudentFeedbacksScreen(
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
      ),
    );
  }
}
