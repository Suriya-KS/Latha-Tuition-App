import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';

class StudentApprovalDetailsScreen extends StatefulWidget {
  const StudentApprovalDetailsScreen({
    required this.studentDetails,
    super.key,
  });

  final Map<String, dynamic> studentDetails;

  @override
  State<StudentApprovalDetailsScreen> createState() =>
      _StudentApprovalDetailsScreenState();
}

class _StudentApprovalDetailsScreenState
    extends State<StudentApprovalDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController feesAmountController;

  void approveStudentHandler() {
    if (!formKey.currentState!.validate()) return;

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    feesAmountController = TextEditingController();
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

    return Scaffold(
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
                      text: widget.studentDetails['parentsName'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.group_outlined,
                      text: widget.studentDetails['parentalRole'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.phone_outlined,
                      text: widget.studentDetails['parentsPhoneNumber'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.mail_outline,
                      text: widget.studentDetails['parentsEmailAddress'],
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
                        items: dummyBatchNames,
                        onChanged: (value) {},
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
                          const PrimaryButton(
                            title: 'Reject',
                            isOutlined: true,
                          ),
                          PrimaryButton(
                            title: 'Approve',
                            onPressed: approveStudentHandler,
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
    );
  }
}
