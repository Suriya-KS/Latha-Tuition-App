import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/bottom_navigation_bar/curved_bottom_navigation_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/events_view.dart';

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  static const pages = [Placeholder(), EventsView(), Placeholder()];

  int currentPageIndex = 0;

  void changeView(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void popHandler(bool didPop) {
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
      onPopInvoked: popHandler,
      child: Scaffold(
        bottomNavigationBar: CurvedBottomNavigationBar(
          index: currentPageIndex,
          onTap: changeView,
        ),
        body: SafeArea(
          child: pages[currentPageIndex],
        ),
      ),
    );
  }
}
