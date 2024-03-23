import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/registration_sheet.dart';
import 'package:latha_tuition_app/widgets/onboarding/onboarding_page.dart';

class OnboardingPageList extends ConsumerWidget {
  const OnboardingPageList({
    required this.liquidController,
    required this.currentPageIndex,
    required this.lastPageIndex,
    required this.onPageChange,
    super.key,
  });

  final LiquidController liquidController;
  final int currentPageIndex;
  final int lastPageIndex;
  final void Function(int) onPageChange;

  void showRegistrationSheet(BuildContext context, WidgetRef ref) {
    final awaitingAdmissionMethods =
        ref.read(awaitingAdmissionProvider.notifier);

    awaitingAdmissionMethods.setParentContext(context);
    awaitingAdmissionMethods.setParentRef(ref);

    modalBottomSheet(
      context,
      const RegistrationSheet(screen: Screen.onboarding),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiquidSwipe(
      slideIconWidget: currentPageIndex < lastPageIndex
          ? const Icon(
              Icons.keyboard_double_arrow_left,
            )
          : const SizedBox.shrink(),
      enableLoop: false,
      positionSlideIcon: 0.85,
      liquidController: liquidController,
      onPageChangeCallback: onPageChange,
      pages: [
        const OnboardingPage(
          image: teachingImage,
          title: 'Guided Academic Journey',
          color: Colors.white,
          contents: [
            Text(
              'Embark on a personalized learning journey with our expert tutor, ensuring tailored tuition for a uniquely successful academic experience',
            ),
          ],
        ),
        const OnboardingPage(
          image: studyingImage,
          title: 'Success Crafted Together',
          color: Color.fromARGB(255, 248, 229, 233),
          contents: [
            Text(
              'Unlock your academic potential with expert guidance and seamless tuition management, shaping a brighter future collaboratively',
            ),
          ],
        ),
        OnboardingPage(
          image: welcomeImage,
          title: "Alright, Let's Get Started!",
          color: const Color.fromARGB(255, 213, 255, 253),
          contents: [
            const SizedBox(height: 80),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                iconData: Icons.arrow_right_alt,
                onPressed: () => showRegistrationSheet(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
