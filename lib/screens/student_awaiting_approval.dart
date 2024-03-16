import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/providers/admission_provider.dart';
import 'package:latha_tuition_app/screens/student_sign_up.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/fetch_admission_status_sheet.dart';

class StudentAwaitingApprovalScreen extends ConsumerStatefulWidget {
  const StudentAwaitingApprovalScreen({super.key});

  @override
  ConsumerState<StudentAwaitingApprovalScreen> createState() =>
      _StudentAwaitingApprovalScreenState();
}

class _StudentAwaitingApprovalScreenState
    extends ConsumerState<StudentAwaitingApprovalScreen> {
  final firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  bool errorOccurred = false;
  String title = 'Application Under Review';
  String image = waitingImage;
  late String studentName;
  late String studentEmailAddress;
  late String studentPhoneNumber;

  void showFetchAdmissionStatusSheet(BuildContext context) {
    ref.read(awaitingAdmissionProvider.notifier).setParentContext(context);

    modalBottomSheet(context, const FetchAdmissionStatusSheet());
  }

  void checkAdmissionApprovalStatus(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorOccurred = false;
    });

    final awaitingAdmissionStudentID =
        ref.read(awaitingAdmissionProvider)[AwaitingAdmission.studentID];

    final documentSnapshot = await firestore
        .collection('studentAdmissionRequests')
        .doc(awaitingAdmissionStudentID)
        .get();

    final studentDetails = documentSnapshot.data();

    if (studentDetails == null && context.mounted) {
      setState(() {
        isLoading = false;
        errorOccurred = true;
        title = 'Something Went Wrong';
        image = errorImage;
      });

      ref.read(awaitingAdmissionProvider.notifier).setParentContext(context);

      modalBottomSheet(context, const FetchAdmissionStatusSheet());

      return;
    }

    if (studentDetails!['awaitingApproval']) {
      setState(() {
        isLoading = false;
        title = 'Application Under Review';
        image = waitingImage;
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
  }

  @override
  void initState() {
    super.initState();

    checkAdmissionApprovalStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          ? () => showFetchAdmissionStatusSheet(context)
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
    );
  }
}
