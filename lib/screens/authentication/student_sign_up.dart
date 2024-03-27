import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/admission_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/authentication/student_sign_up_form.dart';

class StudentSignUpScreen extends ConsumerWidget {
  const StudentSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admissionData =
        ref.watch(admissionProvider)[Admission.studentDetails];
    final isLoading = ref.watch(loadingProvider);
    final screenSize = MediaQuery.of(context);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: ScrollableImageContent(
            title: 'Congratulations',
            description:
                'Admission approved, marking the final step! Create your password by signing up to complete enrollment',
            imagePath: celebrateImage,
            screenSize: screenSize,
            child: Column(
              children: [
                InfoCard(
                  icon: Icons.info_outline,
                  children: [
                    TextWithIcon(
                      icon: Icons.groups_outlined,
                      text: admissionData['batch'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.currency_rupee_outlined,
                      text:
                          '${formatAmount(admissionData['feesAmount'])} per month',
                    ),
                  ],
                ),
                const SizedBox(height: screenPadding),
                const StudentSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
