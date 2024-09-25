import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/forgot_password_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class SendVerificationLinkForm extends ConsumerStatefulWidget {
  const SendVerificationLinkForm({super.key});

  @override
  ConsumerState<SendVerificationLinkForm> createState() =>
      _SendVerificationLinkFormState();
}

class _SendVerificationLinkFormState
    extends ConsumerState<SendVerificationLinkForm> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController controller;

  void sendVerificationLinkHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final emailAddress = controller.text;
    final loadingMethods = ref.read(loadingProvider.notifier);
    final authentication = FirebaseAuth.instance;

    loadingMethods.setLoadingStatus(true);

    try {
      final errorMessage = await validateForgotPasswordEmail(emailAddress);

      if (errorMessage != null) {
        loadingMethods.setLoadingStatus(false);

        if (!context.mounted) return;

        snackBar(
          context,
          content: Text(errorMessage),
        );
        return;
      }

      await authentication.sendPasswordResetEmail(
        email: emailAddress.trim(),
      );

      ref
          .read(forgotPasswordProvider.notifier)
          .switchToAcknowledgementContent(emailAddress);

      loadingMethods.setLoadingStatus(false);
    } on FirebaseAuthException catch (error) {
      final errorMessage = validateAuthentication(error);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;
      if (errorMessage == null) return;

      snackBar(
        context,
        content: Text(errorMessage),
      );
    } catch (error) {
      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextInput(
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outline,
            inputType: TextInputType.emailAddress,
            controller: controller,
            validator: validateEmail,
          ),
          const SizedBox(height: 50),
          PrimaryButton(
            title: 'Send Verification Link',
            onPressed: () => sendVerificationLinkHandler(context),
          ),
        ],
      ),
    );
  }
}
