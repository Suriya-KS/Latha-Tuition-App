import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/utilities/curved_bottom_navigation_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_home_view.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_events_view.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_student_administration_view.dart';

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  static const pages = [
    TutorHomeView(),
    TutorEventsView(),
    TutorStudentAdministrationView(),
  ];

  int currentPageIndex = 0;

  void changeView(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void dashboardPopHandler(bool didPop) {
    if (currentPageIndex != 0) {
      setState(() {
        currentPageIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentPageIndex == 0 ? true : false,
      onPopInvoked: dashboardPopHandler,
      child: Scaffold(
        bottomNavigationBar: CurvedBottomNavigationBar(
          index: currentPageIndex,
          onTap: changeView,
          items: [
            Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.background,
              size: 30,
            ),
            Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.background,
              size: 30,
            ),
            Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.background,
              size: 30,
            ),
          ],
        ),
        body: pages[currentPageIndex],
      ),
    );
  }
}
