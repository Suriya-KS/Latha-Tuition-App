import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/form_inputs/month_input.dart';
import 'package:latha_tuition_app/widgets/student_dashboard/student_test_marks_list.dart';

class StudentTestMarksView extends StatefulWidget {
  const StudentTestMarksView({super.key});

  @override
  State<StudentTestMarksView> createState() => _StudentTestViewState();
}

class _StudentTestViewState extends State<StudentTestMarksView> {
  final items = dummyStudentTestMarks;

  ViewMode currentView = ViewMode.list;

  void changeTestMarksView() {
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
        const TextAppBar(title: 'Test Marks Records'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    : StudentTestMarksList(view: currentView),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
