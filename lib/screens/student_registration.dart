import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/student_registration/student_registration_form.dart';

class StudentRegistrationScreen extends ConsumerWidget {
  const StudentRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final screenSize = MediaQuery.of(context);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: ScrollableImageContent(
            title: 'Enroll for Excellence',
            description:
                'Take control of your educational journey and pave the way to a brighter future',
            imagePath: newEntryImage,
            screenSize: screenSize,
            child: Column(
              children: [
                const StudentRegistrationForm(),
                const SizedBox(height: 10),
                InfoActionButton(
                  infoText: 'Already a student?',
                  buttonText: 'Login here',
                  onPressed: () => navigateToLoginScreen(
                    context,
                    Screen.studentRegistration,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
