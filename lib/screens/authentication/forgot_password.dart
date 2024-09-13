import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/authentication/acknowledge_verification_link_sent.dart';
import 'package:latha_tuition_app/widgets/authentication/send_verification_link_form.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context);

    final forgotPasswordData = ref.watch(forgotPasswordProvider);
    final inputText = forgotPasswordData[ForgotPassword.inputText];
    final activeContent = forgotPasswordData[ForgotPassword.activeContent];

    return PopScope(
      onPopInvoked: (didPop) =>
          ref.read(forgotPasswordProvider.notifier).resetState(),
      child: Scaffold(
        body: SafeArea(
          child: ScrollableImageContent(
            title: 'Recover Your Account',
            description:
                "Forgotten your password? No worries! We'll assist you in resetting it securely",
            imagePath: Theme.of(context).brightness == Brightness.light
                ? forgotPasswordImage
                : forgotPasswordImageDark,
            screenSize: screenSize,
            child: Column(
              children: [
                if (activeContent == ForgotPasswordContent.sendVerificationLink)
                  const SendVerificationLinkForm(),
                if (activeContent == ForgotPasswordContent.acknowledgement &&
                    inputText != '')
                  const AcknowledgementVerificationLinkSent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
