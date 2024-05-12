import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/buttons/info_action_button.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/get_started_sheet.dart';
import 'package:latha_tuition_app/widgets/authentication/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void showGetStartedSheet(BuildContext context, WidgetRef ref) {
    final awaitingAdmissionMethods =
        ref.read(awaitingAdmissionProvider.notifier);

    awaitingAdmissionMethods.setParentContext(context);
    awaitingAdmissionMethods.setParentRef(ref);

    modalBottomSheet(
      context,
      const GetStartedSheet(screen: Screen.login),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final screenSize = MediaQuery.of(context);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: ScrollableImageContent(
            title: 'Resume Your Learning',
            description:
                "Welcome back! It's time to resume your academic journey",
            imagePath: Theme.of(context).brightness == Brightness.light
                ? loginImage
                : loginImageDark,
            screenSize: screenSize,
            child: Column(
              children: [
                const LoginForm(),
                const SizedBox(height: 10),
                InfoActionButton(
                  infoText: 'New here?',
                  buttonText: 'Join Us',
                  onPressed: () => showGetStartedSheet(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
