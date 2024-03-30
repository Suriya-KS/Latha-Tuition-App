import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_student_administration_action_list.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/tutor_student_administration_configurations.dart';

class TutorStudentAdministrationView extends ConsumerWidget {
  const TutorStudentAdministrationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return LoadingOverlay(
      isLoading: isLoading,
      child: const Column(
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
      ),
    );
  }
}
