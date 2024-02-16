import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/screens/forgot_password.dart';
import 'package:latha_tuition_app/widgets/buttons/icon_with_text_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';

class PasswordRecoveryOptionSheet extends ConsumerWidget {
  const PasswordRecoveryOptionSheet({super.key});

  void navigateToForgotPasswordScreen(
    BuildContext context,
    WidgetRef ref,
    PasswordRecoveryMethod recoveryMethod,
  ) {
    final forgotPasswordMethods = ref.read(forgotPasswordProvider.notifier);

    forgotPasswordMethods.resetState();
    forgotPasswordMethods.setRecoveryMethod(recoveryMethod);

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const TitleText(title: 'Select Recovery Method'),
        const SizedBox(height: 50),
        Column(
          children: [
            IconWithTextButton(
              title: 'E-mail',
              description: 'Reset via email verification',
              icon: Icons.mail_outline,
              onPressed: () => navigateToForgotPasswordScreen(
                context,
                ref,
                PasswordRecoveryMethod.email,
              ),
            ),
            const SizedBox(height: 20),
            IconWithTextButton(
              title: 'SMS',
              description: 'Reset via SMS verification',
              icon: Icons.phone_iphone_outlined,
              onPressed: () => navigateToForgotPasswordScreen(
                context,
                ref,
                PasswordRecoveryMethod.sms,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
