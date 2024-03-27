import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/widgets/utilities/calendar.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_attendance_list.dart';

class StudentAttendanceView extends StatefulWidget {
  const StudentAttendanceView({super.key});

  @override
  State<StudentAttendanceView> createState() => _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends State<StudentAttendanceView> {
  final items = dummyStudentAttendance;

  ViewMode currentView = ViewMode.list;

  void changeAttendanceView() {
    setState(() {
      if (currentView == ViewMode.calendar) {
        currentView = ViewMode.list;
      } else {
        currentView = ViewMode.calendar;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextAppBar(
          title: 'Attendance Records',
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: changeAttendanceView,
              icon: currentView == ViewMode.calendar
                  ? const Icon(Icons.format_list_bulleted_outlined)
                  : const Icon(Icons.calendar_month_outlined),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (currentView == ViewMode.calendar) const Calendar(),
                if (currentView == ViewMode.list)
                  MonthInput(onChange: (date) {}),
                const SizedBox(height: 20),
                items.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          SvgPicture.asset(
                            notFoundImage,
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          const Text('No Records Found!'),
                        ],
                      )
                    : StudentAttendanceList(view: currentView),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
