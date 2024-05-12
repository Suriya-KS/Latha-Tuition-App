import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/utilities/alert_dialogue.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';

class TutorStudentPersonalDetailsView extends ConsumerStatefulWidget {
  const TutorStudentPersonalDetailsView({super.key});

  @override
  ConsumerState<TutorStudentPersonalDetailsView> createState() =>
      _TutorStudentPersonalDetailsViewState();
}

class _TutorStudentPersonalDetailsViewState
    extends ConsumerState<TutorStudentPersonalDetailsView> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  bool isChanged = false;
  List<String> batchNames = [];
  Map<String, dynamic> studentDetails = {
    'name': '',
    'emailAddress': '',
    'phoneNumber': '',
    'gender': '',
    'batch': '',
    'feesAmount': '',
    'schoolName': '',
    'academicYear': '',
    'educationBoard': '',
    'standard': '',
    'addressLine1': '',
    'addressLine2': '',
    'pincode': '',
    'city': '',
    'state': '',
    'country': '',
    'parentName': '',
    'parentalRole': '',
    'parentPhoneNumber': '',
    'parentEmailAddress': '',
  };

  late String? selectedBatch;
  late TextEditingController feesAmountController;

  void resetBatchAndFeesAmount() {
    feesAmountController.clear();

    setState(() {
      isChanged = false;
      selectedBatch = studentDetails['batch'];
      feesAmountController.text = studentDetails['feesAmount'].toString();
    });

    snackBar(
      context,
      content: const Text(
        'Changes discarded: Batch and fees amount have been reset',
      ),
    );
  }

  void updateBatchAndFeesAmount(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final studentID =
        ref.read(tutorSearchProvider)[TutorSearch.selectedStudentID];
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    try {
      await firestore.collection('students').doc(studentID).update({
        'batch': selectedBatch,
        'feesAmount': num.parse(feesAmountController.text),
      });

      setState(() {
        isChanged = false;
      });

      loadingMethods.setLoadingStatus(false);
    } catch (error) {
      setState(() {
        isChanged = false;
      });

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

    studentDetails = getStudentDetails(ref);
    batchNames = ref.read(tutorSearchProvider)[TutorSearch.batchNames];

    selectedBatch = studentDetails['batch'];
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

    if (studentDetails['gender'] == 'Male') {
      genderIcon = Icons.male_outlined;
    } else if (studentDetails['gender'] == 'Female') {
      genderIcon = Icons.female_outlined;
    } else {
      genderIcon = Icons.transgender_outlined;
    }

    return PopScope(
      canPop: !isChanged,
      onPopInvoked: (didPop) => !didPop
          ? alertDialogue(
              context,
              actions: [
                TextButton(
                  onPressed: () => closeAlertDialogue(
                    context,
                    function: (context) => resetBatchAndFeesAmount(),
                  ),
                  child: const Text('Discard'),
                ),
                OutlinedButton(
                  onPressed: () => closeAlertDialogue(
                    context,
                    function: updateBatchAndFeesAmount,
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          : null,
      child: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(screenPadding),
            child: Column(
              children: [
                InfoCard(
                  icon: Icons.person_outline,
                  children: [
                    TextWithIcon(
                      icon: Icons.phone_outlined,
                      text: studentDetails['phoneNumber'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.mail_outline,
                      text: studentDetails['emailAddress'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: genderIcon,
                      text: studentDetails['gender'],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InfoCard(
                  icon: Icons.school_outlined,
                  children: [
                    TextWithIcon(
                      icon: Icons.apartment_outlined,
                      text: studentDetails['schoolName'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.calendar_month_outlined,
                      text: studentDetails['academicYear'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.menu_book_outlined,
                      text: studentDetails['educationBoard'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.class_outlined,
                      text: studentDetails['standard'],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InfoCard(
                  icon: Icons.location_on_outlined,
                  children: [
                    Text(
                      '${studentDetails['addressLine1']}, ${studentDetails['addressLine2']}, \n${studentDetails['city']} - ${studentDetails['pincode']}, \n${studentDetails['state']}, ${studentDetails['country']}.',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InfoCard(
                  icon: Icons.family_restroom_outlined,
                  children: [
                    TextWithIcon(
                      icon: Icons.person_outline,
                      text: studentDetails['parentName'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.group_outlined,
                      text: studentDetails['parentalRole'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.phone_outlined,
                      text: studentDetails['parentPhoneNumber'],
                    ),
                    const SizedBox(height: 5),
                    TextWithIcon(
                      icon: Icons.mail_outline,
                      text: studentDetails['parentEmailAddress'],
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
                        initialValue: selectedBatch,
                        onChanged: (value) => setState(() {
                          isChanged = true;
                          selectedBatch = value;
                        }),
                        validator: validateDropdownValue,
                      ),
                      const SizedBox(height: 10),
                      TextInput(
                        labelText: 'Fees Amount',
                        prefixIcon: Icons.currency_rupee,
                        inputType: TextInputType.number,
                        initialValue: studentDetails['feesAmount'].toString(),
                        onChanged: (value) => setState(() {
                          isChanged = true;
                        }),
                        controller: feesAmountController,
                        validator: validateFeesAmount,
                      ),
                      if (isChanged) const SizedBox(height: 50),
                      if (isChanged)
                        PrimaryButton(
                          title: 'Update',
                          onPressed: () => updateBatchAndFeesAmount(context),
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
