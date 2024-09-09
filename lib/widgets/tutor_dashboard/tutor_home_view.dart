import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/authentication_provider.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/providers/home_view_provider.dart';
import 'package:latha_tuition_app/providers/schedule_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/floating_circular_action_button.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_badge_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/tutor_schedule_sheet.dart';
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
  ScaffoldMessengerState? scaffoldMessengerState;

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

  Future<void> loadBatches(BuildContext context) async {
    final settingsDocumentSnapshot =
        await firestore.collection('settings').doc('studentRegistration').get();

    if (!settingsDocumentSnapshot.exists) return;

    final settings = settingsDocumentSnapshot.data()!;

    if (!settings.containsKey('batchNames')) return;

    ref
        .read(scheduleProvider.notifier)
        .loadBatches(List<String>.from(settings['batchNames']));
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

  Future<void> loadUpcomingClasses(BuildContext context) async {
    final yesterdaysDate = DateTime.now().subtract(const Duration(days: 1));

    setState(() {
      isLoading = true;
    });

    try {
      final upcomingClassesQuerySnapshot = await firestore
          .collection('upcomingClasses')
          .where(
            'date',
            isGreaterThan: Timestamp.fromDate(yesterdaysDate),
          )
          .orderBy('date')
          .orderBy('startTime')
          .get();

      final upcomingClassesSummary = upcomingClassesQuerySnapshot.docs
          .map((upcomingClassesQueryDocumentSnapshot) => {
                'id': upcomingClassesQueryDocumentSnapshot.id,
                'batchName':
                    upcomingClassesQueryDocumentSnapshot.data()['batch'],
                'date': upcomingClassesQueryDocumentSnapshot
                    .data()['date']
                    .toDate(),
                'startTime': timestampToTimeOfDay(
                  upcomingClassesQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  upcomingClassesQueryDocumentSnapshot.data()['endTime'],
                ),
              })
          .toList();

      ref
          .read(homeViewProvider.notifier)
          .setUpcomingClasses(upcomingClassesSummary);

      setState(() {
        isLoading = false;
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

  Future<void> loadScheduledTests(BuildContext context) async {
    final yesterdaysDate = DateTime.now().subtract(const Duration(days: 1));

    setState(() {
      isLoading = true;
    });

    try {
      final scheduledTestsQuerySnapshot = await firestore
          .collection('scheduledTests')
          .where(
            'date',
            isGreaterThan: Timestamp.fromDate(yesterdaysDate),
          )
          .orderBy('date')
          .orderBy('startTime')
          .get();

      final scheduledTestsSummary = scheduledTestsQuerySnapshot.docs
          .map((scheduledTestsQueryDocumentSnapshot) => {
                'id': scheduledTestsQueryDocumentSnapshot.id,
                'testName': scheduledTestsQueryDocumentSnapshot.data()['name'],
                'batchName':
                    scheduledTestsQueryDocumentSnapshot.data()['batch'],
                'date':
                    scheduledTestsQueryDocumentSnapshot.data()['date'].toDate(),
                'startTime': timestampToTimeOfDay(
                  scheduledTestsQueryDocumentSnapshot.data()['startTime'],
                ),
                'endTime': timestampToTimeOfDay(
                  scheduledTestsQueryDocumentSnapshot.data()['endTime'],
                ),
              })
          .toList();

      ref
          .read(homeViewProvider.notifier)
          .setScheduledTests(scheduledTestsSummary);

      setState(() {
        isLoading = false;
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

  void showSchedulingBottomSheet(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await loadBatches(context);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      final didScheduleHistoryChange = await modalBottomSheet(
            context,
            const TutorScheduleSheet(),
          ) ??
          false;

      if (!didScheduleHistoryChange) return;
      if (!context.mounted) return;

      final activeToggle = ref.read(homeViewProvider)[HomeView.activeToggle];

      if (activeToggle == HomeViewToggles.classes) {
        await loadUpcomingClasses(context);
      } else if (activeToggle == HomeViewToggles.tests) {
        await loadScheduledTests(context);
      }
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final activeToggle = ref.read(homeViewProvider)[HomeView.activeToggle];

    loadTutorName(context);
    loadStudentAdmissionRequestCount(context);
    loadStudentPaymentRequestsCount(context);

    if (activeToggle == HomeViewToggles.classes) loadUpcomingClasses(context);
    if (activeToggle == HomeViewToggles.tests) loadScheduledTests(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    scaffoldMessengerState?.hideCurrentSnackBar();

    super.dispose();
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
                    (context, index) => TutorHomeContents(
                      loadUpcomingClasses: loadUpcomingClasses,
                      loadScheduledTests: loadScheduledTests,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!animatedDrawerData[AnimatedDrawer.isOpen])
            FloatingCircularActionButton(
              onPressed: () => showSchedulingBottomSheet(
                context,
              ),
              icon: Icons.add,
            ),
        ],
      ),
    );
  }
}
