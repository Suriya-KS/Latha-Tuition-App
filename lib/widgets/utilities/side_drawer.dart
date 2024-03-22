import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latha_tuition_app/screens/onboarding.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  void signOutHandler(BuildContext context, WidgetRef ref) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await FirebaseAuth.instance.signOut();

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
        (route) => false,
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
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: ref.read(animatedDrawerProvider.notifier).toggleAnimatedDrawer,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(title: formatName('Tutor Name')),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => signOutHandler(context, ref),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout_outlined),
                      SizedBox(width: 10),
                      Text('Log Out'),
                    ],
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
