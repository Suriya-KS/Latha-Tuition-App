import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class AcknowledgementVerificationLinkSent extends ConsumerWidget {
  const AcknowledgementVerificationLinkSent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordData = ref.watch(forgotPasswordProvider);
    final inputText = forgotPasswordData[ForgotPassword.inputText];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Verification link is sent to ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                TextSpan(
                  text: inputText,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextSpan(
                  text: '. Reset your password and log back in!',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: PrimaryButton(
              title: 'Login',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
