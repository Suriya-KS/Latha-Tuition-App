import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/utilities/curved_bottom_navigation_bar.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_home_view.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_attendance_view.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_test_marks_view.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  static const pages = [
    StudentHomeView(),
    StudentAttendanceView(),
    StudentTestMarksView(),
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
              Icons.groups_outlined,
              color: Theme.of(context).colorScheme.background,
              size: 30,
            ),
            Icon(
              Icons.assignment_outlined,
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
