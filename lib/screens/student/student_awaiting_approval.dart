import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/providers/admission_provider.dart';
import 'package:latha_tuition_app/screens/authentication/student_sign_up.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/student_fetch_admission_status_sheet.dart';

class StudentAwaitingApprovalScreen extends ConsumerStatefulWidget {
  const StudentAwaitingApprovalScreen({super.key});

  @override
  ConsumerState<StudentAwaitingApprovalScreen> createState() =>
      _StudentAwaitingApprovalScreenState();
}

class _StudentAwaitingApprovalScreenState
    extends ConsumerState<StudentAwaitingApprovalScreen> {
  final studentAdmissionRequestsCollectionReference =
      FirebaseFirestore.instance.collection('studentAdmissionRequests');

  bool isLoading = true;
  bool errorOccurred = false;
  String title = 'Application Under Review';
  String image = awaitingApprovalImageDark;

  String studentName = '';
  String studentEmailAddress = '';
  String studentPhoneNumber = '';

  void showStudentFetchAdmissionStatusSheet() {
    final awaitingAdmissionMethods =
        ref.read(awaitingAdmissionProvider.notifier);

    awaitingAdmissionMethods.setParentContext(context);
    awaitingAdmissionMethods.setParentRef(ref);

    modalBottomSheet(context, const StudentFetchAdmissionStatusSheet());
  }

  void checkAdmissionApprovalStatus(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorOccurred = false;
    });

    final awaitingAdmissionStudentID =
        ref.read(awaitingAdmissionProvider)[AwaitingAdmission.studentID];

    try {
      final studentAdmissionRequestsDocumentSnapshot =
          await studentAdmissionRequestsCollectionReference
              .doc(awaitingAdmissionStudentID)
              .get();

      final studentDetails = studentAdmissionRequestsDocumentSnapshot.data();

      if (studentDetails == null && context.mounted) {
        setState(() {
          isLoading = false;
          errorOccurred = true;
          title = 'Something Went Wrong';
          image = Theme.of(context).brightness == Brightness.light
              ? warningImage
              : warningImageDark;
        });

        final awaitingAdmissionMethods =
            ref.read(awaitingAdmissionProvider.notifier);

        awaitingAdmissionMethods.setParentContext(context);
        awaitingAdmissionMethods.setParentRef(ref);

        modalBottomSheet(context, const StudentFetchAdmissionStatusSheet());

        return;
      }

      setState(() {
        isLoading = false;
      });

      if (studentDetails!['awaitingApproval']) {
        setState(() {
          title = 'Application Under Review';
          image = Theme.of(context).brightness == Brightness.light
              ? awaitingApprovalImage
              : awaitingApprovalImageDark;
          studentName = studentDetails['name'];
          studentEmailAddress = studentDetails['emailAddress'];
          studentPhoneNumber = studentDetails['phoneNumber'];
        });

        return;
      }

      if (!context.mounted) return;

      ref.read(admissionProvider.notifier).setStudentDetails(studentDetails);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const StudentSignUpScreen(),
        ),
        (route) => false,
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

    checkAdmissionApprovalStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ScrollableImageContent(
                screenSize: MediaQuery.of(context),
                imagePath: image,
                imageHeightFactor: 0.4,
                imageAlignment: Alignment.center,
                title: title,
                description: '',
                child: Column(
                  children: [
                    if (!isLoading && !errorOccurred)
                      InfoCard(
                        icon: null,
                        children: [
                          TextWithIcon(
                            icon: Icons.person_outline,
                            text: studentName,
                          ),
                          const SizedBox(height: 5),
                          TextWithIcon(
                            icon: Icons.mail_outline,
                            text: studentEmailAddress,
                          ),
                          const SizedBox(height: 5),
                          TextWithIcon(
                            icon: Icons.phone_outlined,
                            text: '+91 $studentPhoneNumber',
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (!errorOccurred)
                      TextButton(
                        onPressed: !isLoading
                            ? () => checkAdmissionApprovalStatus(context)
                            : null,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_outlined),
                            SizedBox(width: 5),
                            Text('Refresh'),
                          ],
                        ),
                      ),
                    if (errorOccurred)
                      TextButton(
                        onPressed: !isLoading
                            ? showStudentFetchAdmissionStatusSheet
                            : null,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.manage_search_outlined),
                            SizedBox(width: 5),
                            Text('Fetch Details'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
