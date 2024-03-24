import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_student_administration_action_list.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_student_administration_configurations.dart';

class TutorStudentAdministrationView extends StatelessWidget {
  const TutorStudentAdministrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextAppBar(title: 'Student Administration'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TutorStudentAdministrationActionList(),
                SizedBox(height: 50),
                TutorStudentAdministrationConfigurations(),
                SizedBox(height: screenPadding),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
