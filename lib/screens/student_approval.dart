import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/screens/student_approval_details.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/cards/icon_text_tile.dart';

class StudentApprovalScreen extends StatefulWidget {
  const StudentApprovalScreen({super.key});

  @override
  State<StudentApprovalScreen> createState() => _StudentApprovalScreenState();
}

class _StudentApprovalScreenState extends State<StudentApprovalScreen> {
  late List<Map<String, dynamic>> studentApprovals;

  void navigateToStudentApprovalDetailsScreen(
    BuildContext context,
    Map<String, dynamic> studentDetails,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudentApprovalDetailsScreen(studentDetails: studentDetails),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    studentApprovals = dummyStudentApprovals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TextAppBar(title: 'Student Approval'),
      body: SafeArea(
        child: Column(
          children: [
            for (int i = 0; i < studentApprovals.length; i++)
              IconTextTile(
                title: studentApprovals[i]['name'],
                description: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Standard: '),
                          Text(
                            studentApprovals[i]['standard'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Education Board: '),
                          Text(
                            studentApprovals[i]['educationBoard'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
                icon: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => navigateToStudentApprovalDetailsScreen(
                  context,
                  studentApprovals[i],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
