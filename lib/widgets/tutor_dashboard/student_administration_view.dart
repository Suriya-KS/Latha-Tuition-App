import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/student_administration_action_list.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/student_administration_configurations.dart';

class StudentAdministrationView extends StatelessWidget {
  const StudentAdministrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          TextAppBar(title: 'Student Administration'),
          SizedBox(height: 20),
          StudentAdministrationActionList(),
          SizedBox(height: 50),
          StudentAdministrationConfigurations(),
        ],
      ),
    );
  }
}
