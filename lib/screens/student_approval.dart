import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/screens/student_approval_details.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/icon_text_tile.dart';

class StudentApprovalScreen extends StatefulWidget {
  const StudentApprovalScreen({super.key});

  @override
  State<StudentApprovalScreen> createState() => _StudentApprovalScreenState();
}

class _StudentApprovalScreenState extends State<StudentApprovalScreen> {
  final studentAdmissionRequestsCollectionReference = FirebaseFirestore.instance
      .collection('studentAdmissionRequests')
      .where('awaitingApproval', isEqualTo: true)
      .orderBy('requestedAt');

  bool isLoading = true;
  List<Map<String, dynamic>> studentAdmissionRequests = [];

  void navigateToStudentApprovalDetailsScreen(
    BuildContext context,
    Map<String, dynamic> studentDetails,
  ) async {
    final didStudentAdmissionRequestChange = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudentApprovalDetailsScreen(studentDetails: studentDetails),
          ),
        ) ??
        false;

    if (!didStudentAdmissionRequestChange) return;
    if (!context.mounted) return;

    loadStudentAdmissionRequests(context);
  }

  void loadStudentAdmissionRequests(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final studentAdmissionRequestsQuerySnapshot =
          await studentAdmissionRequestsCollectionReference.get();

      setState(() {
        isLoading = false;
        studentAdmissionRequests = studentAdmissionRequestsQuerySnapshot.docs
            .map((admissionRequestedStudent) => {
                  ...admissionRequestedStudent.data(),
                  'id': admissionRequestedStudent.id,
                })
            .toList();
      });
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

    loadStudentAdmissionRequests(context);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const TextAppBar(title: 'Student Approval'),
        body: SafeArea(
          child: ListView.builder(
            itemCount: studentAdmissionRequests.length + 1,
            itemBuilder: (context, index) =>
                index < studentAdmissionRequests.length
                    ? IconTextTile(
                        title: studentAdmissionRequests[index]['name'],
                        description: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Standard: '),
                                  Text(
                                    studentAdmissionRequests[index]['standard'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Education Board: '),
                                  Text(
                                    studentAdmissionRequests[index]
                                        ['educationBoard'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ]),
                        icon: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => navigateToStudentApprovalDetailsScreen(
                          context,
                          studentAdmissionRequests[index],
                        ),
                      )
                    : const SizedBox(height: 20),
          ),
        ),
      ),
    );
  }
}
