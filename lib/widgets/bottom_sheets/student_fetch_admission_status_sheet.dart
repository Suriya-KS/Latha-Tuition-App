import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/screens/student/student_awaiting_approval.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class StudentFetchAdmissionStatusSheet extends ConsumerStatefulWidget {
  const StudentFetchAdmissionStatusSheet({super.key});

  @override
  ConsumerState<StudentFetchAdmissionStatusSheet> createState() =>
      _StudentFetchAdmissionStatusSheetState();
}

class _StudentFetchAdmissionStatusSheetState
    extends ConsumerState<StudentFetchAdmissionStatusSheet> {
  final studentAdmissionRequestsCollectionReference =
      FirebaseFirestore.instance.collection('studentAdmissionRequests');
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  ScaffoldMessengerState? scaffoldMessengerState;

  late TextEditingController emailController;

  void fetchAdmissionStatusHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final studentAdmissionRequestsQuerySnapshot =
          await studentAdmissionRequestsCollectionReference
              .where('emailAddress', isEqualTo: emailController.text)
              .limit(1)
              .get();

      setState(() {
        isLoading = false;
      });

      if (studentAdmissionRequestsQuerySnapshot.docs.isEmpty &&
          context.mounted) {
        final awaitingAdmissionData = ref.read(awaitingAdmissionProvider);

        snackBar(
          context,
          content: const Text('Email address is not registered'),
          actionLabel: 'Register Now',
          onPressed: () => navigateToStudentRegistrationScreen(
            awaitingAdmissionData[AwaitingAdmission.parentContext],
            awaitingAdmissionData[AwaitingAdmission.parentRef],
            screen: Screen.studentFetchAdmissionStatusSheet,
          ),
        );

        Navigator.pop(context);

        return;
      }

      final authenticationMethods =
          ref.read(awaitingAdmissionProvider.notifier);

      setState(() {
        isLoading = true;
      });

      await authenticationMethods.clearData();
      await authenticationMethods.setStudentID(
        studentAdmissionRequestsQuerySnapshot.docs.first.id,
      );

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentAwaitingApprovalScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      final errorMessage = validateAuthentication(error);

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;
      if (errorMessage == null) return;

      snackBar(
        context,
        content: Text(errorMessage),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });

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

    emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    scaffoldMessengerState?.hideCurrentSnackBar();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(title: 'Check Admission Status'),
        const SizedBox(height: 30),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextInput(
                labelText: 'Email Address',
                prefixIcon: Icons.mail_outlined,
                inputType: TextInputType.emailAddress,
                readOnly: isLoading,
                controller: emailController,
                validator: validateEmail,
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                title: 'Check',
                isLoading: isLoading,
                onPressed: () => fetchAdmissionStatusHandler(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
