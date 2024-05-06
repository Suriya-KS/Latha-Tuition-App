import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/get_started_sheet.dart';
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

  void showGetStartedSheet(BuildContext context, WidgetRef ref) {
    final awaitingAdmissionMethods =
        ref.read(awaitingAdmissionProvider.notifier);

    awaitingAdmissionMethods.setParentContext(context);
    awaitingAdmissionMethods.setParentRef(ref);

    modalBottomSheet(
      context,
      const GetStartedSheet(screen: Screen.onboarding),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiquidSwipe(
      enableLoop: false,
      positionSlideIcon: 0.85,
      liquidController: liquidController,
      onPageChangeCallback: onPageChange,
      pages: [
        OnboardingPage(
          image: onboardingImage1,
          title: 'Guided Academic Journey',
          color: Theme.of(context).colorScheme.background,
          contents: const [
            Text(
              'Embark on a personalized learning journey with our expert tutor, ensuring tailored tuition for a uniquely successful academic experience',
            ),
          ],
        ),
        OnboardingPage(
          image: onboardingImage2,
          title: 'Success Crafted Together',
          color: getThemeMode(context) == Brightness.light
              ? const Color.fromARGB(255, 248, 229, 233)
              : const Color.fromARGB(255, 24, 39, 71),
          contents: const [
            Text(
              'Unlock your academic potential with expert guidance and seamless tuition management, shaping a brighter future collaboratively',
            ),
          ],
        ),
        OnboardingPage(
          image: onboardingImage3,
          title: "Alright, Let's Get Started!",
          color: getThemeMode(context) == Brightness.light
              ? const Color.fromARGB(255, 213, 255, 253)
              : const Color.fromARGB(255, 55, 64, 69),
          contents: [
            const SizedBox(height: 80),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                iconData: Icons.arrow_right_alt,
                onPressed: () => showGetStartedSheet(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
