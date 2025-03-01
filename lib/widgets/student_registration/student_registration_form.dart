import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/utilities/snack_bar.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/awaiting_admission_provider.dart';
import 'package:latha_tuition_app/screens/student/student_awaiting_approval.dart';
import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';

class StudentRegistrationForm extends ConsumerStatefulWidget {
  const StudentRegistrationForm({super.key});

  @override
  ConsumerState<StudentRegistrationForm> createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState
    extends ConsumerState<StudentRegistrationForm> {
  final studentAdmissionRequestsCollectionReference =
      FirebaseFirestore.instance.collection('studentAdmissionRequests');
  final settingsDocumentReference = FirebaseFirestore.instance
      .collection('settings')
      .doc('studentRegistration');
  final formKey = GlobalKey<FormState>();

  String? gender;
  String? academicYear;
  String? educationBoard;
  String? standard;
  String? parentalRole;
  ScaffoldMessengerState? scaffoldMessengerState;
  List<String> educationBoardsAllowed = [];
  List<String> standardsAllowed = [];
  Map<String, bool> isUnique = {
    'emailAddress': true,
    'phoneNumber': true,
    'parentEmailAddress': true,
    'parentPhoneNumber': true,
  };

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController schoolNameController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController pincodeController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController parentNameController;
  late TextEditingController parentPhoneController;
  late TextEditingController parentEmailController;

  List<String> getAcademicYears({
    required int previousYears,
    required int futureYears,
  }) {
    List<String> academicYears = [];
    int currentYear = DateTime.now().year;

    int startYear = currentYear - previousYears;
    int endYear = currentYear + futureYears;

    for (int i = startYear; i <= endYear; i++) {
      final academicYear = "${i.toString()} - ${(i + 1).toString()}";
      academicYears.add(academicYear);
    }

    return academicYears;
  }

  void loadEducationBoardsAndStandards(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    try {
      final settingsDocumentSnapshot = await settingsDocumentReference.get();

      WidgetsBinding.instance.addPostFrameCallback(
        (duration) => loadingMethods.setLoadingStatus(false),
      );

      if (!settingsDocumentSnapshot.exists) return;

      final settings = settingsDocumentSnapshot.data()!;

      if (settings.containsKey('educationBoards')) {
        setState(() {
          educationBoardsAllowed = List<String>.from(
            settings['educationBoards'],
          );
        });
      }

      if (settings.containsKey('enabledStandards')) {
        setState(() {
          standardsAllowed = List<String>.from(
            settings['enabledStandards'],
          );
        });
      }
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback(
        (duration) => loadingMethods.setLoadingStatus(false),
      );

      if (!context.mounted) return;

      snackBar(
        context,
        content: const Text(defaultErrorMessage),
      );
    }
  }

  void studentRegistrationHandler(BuildContext context) async {
    final loadingMethods = ref.read(loadingProvider.notifier);

    loadingMethods.setLoadingStatus(true);

    isUnique['emailAddress'] = await validateUnique(
      emailController.text,
      'emailAddress',
    );

    isUnique['phoneNumber'] = await validateUnique(
      phoneController.text,
      'phoneNumber',
    );

    isUnique['parentEmailAddress'] = await validateUnique(
          parentEmailController.text,
          'parentEmailAddress',
        ) &&
        await validateUnique(
          parentEmailController.text,
          'emailAddress',
        );

    isUnique['parentPhoneNumber'] = await validateUnique(
          parentPhoneController.text,
          'parentPhoneNumber',
        ) &&
        await validateUnique(
          parentPhoneController.text,
          'phoneNumber',
        );

    loadingMethods.setLoadingStatus(false);

    if (!formKey.currentState!.validate()) return;

    loadingMethods.setLoadingStatus(true);

    try {
      final studentAdmissionRequestsDocumentReference =
          await studentAdmissionRequestsCollectionReference.add({
        'name': nameController.text,
        'emailAddress': emailController.text,
        'phoneNumber': phoneController.text,
        'gender': gender,
        'schoolName': schoolNameController.text,
        'academicYear': academicYear,
        'educationBoard': educationBoard,
        'standard': standard,
        'addressLine1': addressLine1Controller.text,
        'addressLine2': addressLine2Controller.text,
        'pincode': pincodeController.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'parentName': parentNameController.text,
        'parentalRole': parentalRole,
        'parentPhoneNumber': parentPhoneController.text,
        'parentEmailAddress': parentEmailController.text,
        'awaitingApproval': true,
        'requestedAt': DateTime.now(),
      });

      await ref
          .read(awaitingAdmissionProvider.notifier)
          .setStudentID(studentAdmissionRequestsDocumentReference.id);

      loadingMethods.setLoadingStatus(false);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const StudentAwaitingApprovalScreen(),
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
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    schoolNameController = TextEditingController();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    pincodeController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    parentNameController = TextEditingController();
    parentPhoneController = TextEditingController();
    parentEmailController = TextEditingController();

    loadEducationBoardsAndStandards(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    schoolNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    parentNameController.dispose();
    parentPhoneController.dispose();
    parentEmailController.dispose();
    scaffoldMessengerState?.hideCurrentSnackBar();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SubtitleText(subtitle: 'Personal Details'),
          TextInput(
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            inputType: TextInputType.name,
            controller: nameController,
            validator: validateName,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
            onChanged: (value) => isUnique['emailAddress'] = true,
            controller: emailController,
            validator: (value) => isUnique['emailAddress']!
                ? validateEmail(
                    value,
                    secondaryField: "parent's email address",
                    secondaryValue: parentEmailController.text,
                  )
                : 'Email address already exists',
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Phone Number',
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            onChanged: (value) => isUnique['phoneNumber'] = true,
            controller: phoneController,
            validator: (value) => isUnique['phoneNumber']!
                ? validatePhoneNumber(
                    value,
                    secondaryField: "parent's phone number",
                    secondaryValue: parentPhoneController.text,
                  )
                : 'Phone number already exists',
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Gender',
            prefixIcon: Icons.transgender_outlined,
            items: const ['Male', 'Female', 'Others'],
            onChanged: (value) => gender = value,
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Educational Details'),
          TextInput(
            labelText: 'School Name',
            prefixIcon: Icons.school_outlined,
            inputType: TextInputType.text,
            controller: schoolNameController,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'school name',
            ),
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Academic Year',
            prefixIcon: Icons.calendar_month_outlined,
            items: getAcademicYears(
              previousYears: 2,
              futureYears: 5,
            ),
            onChanged: (value) => academicYear = value,
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Education Board',
            prefixIcon: Icons.menu_book_outlined,
            items: educationBoardsAllowed,
            onChanged: (value) => educationBoard = value,
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Standard',
            prefixIcon: Icons.class_outlined,
            items: standardsAllowed,
            onChanged: (value) => standard = value,
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Location Details'),
          TextInput(
            labelText: 'Address Line 1',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
            controller: addressLine1Controller,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'address line 1',
            ),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Address Line 2',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
            controller: addressLine2Controller,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'address line 2',
            ),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Pincode',
            prefixIcon: Icons.location_on_outlined,
            inputType: TextInputType.number,
            controller: pincodeController,
            validator: validatePinCode,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'City',
            prefixIcon: Icons.location_city_outlined,
            inputType: TextInputType.text,
            controller: cityController,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'city',
            ),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'State',
            prefixIcon: Icons.map_outlined,
            inputType: TextInputType.text,
            controller: stateController,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'state',
            ),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Country',
            prefixIcon: Icons.public_outlined,
            inputType: TextInputType.text,
            controller: countryController,
            validator: (value) => validateRequiredInput(
              value,
              'your',
              'country',
            ),
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: "Parent's Details"),
          TextInput(
            labelText: "Parent's Name",
            prefixIcon: Icons.group_outlined,
            inputType: TextInputType.name,
            controller: parentNameController,
            validator: validateName,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Parental Role',
            prefixIcon: Icons.family_restroom_outlined,
            items: const ['Father', 'Mother', 'Guardian'],
            onChanged: (value) => parentalRole = value,
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: "Parent's Email Address",
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
            onChanged: (value) => isUnique['parentEmailAddress'] = true,
            controller: parentEmailController,
            validator: (value) => isUnique['parentEmailAddress']!
                ? validateEmail(
                    value,
                    secondaryField: "student's email address",
                    secondaryValue: emailController.text,
                  )
                : 'Email address already exists',
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: "Parent's Phone Number",
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            onChanged: (value) => isUnique['parentPhoneNumber'] = true,
            controller: parentPhoneController,
            validator: (value) => isUnique['parentPhoneNumber']!
                ? validatePhoneNumber(
                    value,
                    secondaryField: "student's phone number",
                    secondaryValue: phoneController.text,
                  )
                : 'Phone number already exists',
          ),
          const SizedBox(height: 50),
          PrimaryButton(
            title: 'Enroll',
            onPressed: () => studentRegistrationHandler(context),
          ),
        ],
      ),
    );
  }
}
