import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/student_sign_up/student_sign_up_form.dart';

class StudentSignUpScreen extends StatelessWidget {
  const StudentSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: ScrollableImageContent(
          title: 'Congratulations',
          description:
              'Admission approved, marking the final step! Create your password by signing up to complete enrollment',
          imagePath: celebrateImage,
          screenSize: screenSize,
          child: const StudentSignUpForm(),
        ),
      ),
    );
  }
}
