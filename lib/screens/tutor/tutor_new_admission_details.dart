import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';

class TutorNewAdmissionDetailsScreen extends StatefulWidget {
  const TutorNewAdmissionDetailsScreen({
    required this.studentDetails,
    super.key,
  });

  final Map<String, dynamic> studentDetails;

  @override
  State<TutorNewAdmissionDetailsScreen> createState() =>
      _TutorNewAdmissionDetailsScreenState();
}

class _TutorNewAdmissionDetailsScreenState
    extends State<TutorNewAdmissionDetailsScreen> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  bool isLoading = true;
  String? selectedBatch;
  List<String> batchNames = [];

  late TextEditingController feesAmountController;

  void loadBatches(BuildContext context) async {
    try {
      final settingsDocumentSnapshot = await firestore
          .collection('settings')
          .doc('studentRegistration')
          .get();

      setState(() {
        isLoading = false;
      });

      if (!settingsDocumentSnapshot.exists) return;

      final settings = settingsDocumentSnapshot.data()!;

      if (!settings.containsKey('batchNames')) return;

      setState(() {
        batchNames = List<String>.from(
          settings['batchNames'],
        );
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

  void approveStudentHandler(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final studentDetails = {...widget.studentDetails};
    final studentID = studentDetails['id'];

    studentDetails.remove('id');
    studentDetails['awaitingApproval'] = false;
    studentDetails['batch'] = selectedBatch;
    studentDetails['feesAmount'] = feesAmountController.text;

    try {
      await firestore
          .collection('studentAdmissionRequests')
          .doc(studentID)
          .set({...studentDetails});

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.pop(context, true);
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

  void rejectStudentHandler(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      await firestore
          .collection('studentAdmissionRequests')
          .doc(widget.studentDetails['id'])
          .delete();

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      Navigator.pop(context, true);
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

    feesAmountController = TextEditingController();

    loadBatches(context);
  }

  @override
  void dispose() {
    feesAmountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData genderIcon;

    if (widget.studentDetails['gender'] == 'Male') {
      genderIcon = Icons.male_outlined;
    } else if (widget.studentDetails['gender'] == 'Female') {
      genderIcon = Icons.female_outlined;
    } else {
      genderIcon = Icons.transgender_outlined;
    }

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: const TextAppBar(title: 'Student Details'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: screenPadding,
              ),
              child: Column(
                children: [
                  InfoCard(
                    icon: Icons.person_outline,
                    children: [
                      TextWithIcon(
                        icon: Icons.person_outline,
                        text: widget.studentDetails['name'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.phone_outlined,
                        text: widget.studentDetails['phoneNumber'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.mail_outline,
                        text: widget.studentDetails['emailAddress'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: genderIcon,
                        text: widget.studentDetails['gender'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InfoCard(
                    icon: Icons.school_outlined,
                    children: [
                      TextWithIcon(
                        icon: Icons.apartment_outlined,
                        text: widget.studentDetails['schoolName'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.calendar_month_outlined,
                        text: widget.studentDetails['academicYear'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.menu_book_outlined,
                        text: widget.studentDetails['educationBoard'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.class_outlined,
                        text: widget.studentDetails['standard'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InfoCard(
                    icon: Icons.location_on_outlined,
                    children: [
                      Text(
                        '${widget.studentDetails['addressLine1']}, ${widget.studentDetails['addressLine2']}, \n${widget.studentDetails['city']} - ${widget.studentDetails['pincode']}, \n${widget.studentDetails['state']}, ${widget.studentDetails['country']}.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InfoCard(
                    icon: Icons.family_restroom_outlined,
                    children: [
                      TextWithIcon(
                        icon: Icons.person_outline,
                        text: widget.studentDetails['parentName'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.group_outlined,
                        text: widget.studentDetails['parentalRole'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.phone_outlined,
                        text: widget.studentDetails['parentPhoneNumber'],
                      ),
                      const SizedBox(height: 5),
                      TextWithIcon(
                        icon: Icons.mail_outline,
                        text: widget.studentDetails['parentEmailAddress'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        DropdownInput(
                          labelText: 'Batch',
                          prefixIcon: Icons.groups_outlined,
                          items: batchNames,
                          onChanged: (value) => setState(() {
                            selectedBatch = value;
                          }),
                          validator: validateDropdownValue,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          labelText: 'Fees Amount',
                          prefixIcon: Icons.currency_rupee,
                          inputType: TextInputType.number,
                          controller: feesAmountController,
                          validator: validateFeesAmount,
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryButton(
                              title: 'Reject',
                              isOutlined: true,
                              onPressed: () => rejectStudentHandler(context),
                            ),
                            PrimaryButton(
                              title: 'Approve',
                              onPressed: () => approveStudentHandler(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: screenPadding),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
