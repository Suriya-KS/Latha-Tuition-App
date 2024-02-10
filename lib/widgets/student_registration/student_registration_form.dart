import 'package:flutter/material.dart';
import 'package:latha_tuition_app/screens/student_sign_up.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';

import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class StudentRegistrationForm extends StatefulWidget {
  const StudentRegistrationForm({super.key});

  @override
  State<StudentRegistrationForm> createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final parentNameController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentEmailController = TextEditingController();

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

  void navigateToStudentSignUpScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const StudentSignUpScreen(),
        ),
        (route) => false);
  }

  void submitFormHandler() {
    if (formKey.currentState!.validate()) {
      navigateToStudentSignUpScreen();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
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
            labelText: 'Phone Number',
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            controller: phoneController,
            validator: validatePhoneNumber,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
            controller: emailController,
            validator: validateEmail,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Gender',
            prefixIcon: Icons.transgender_outlined,
            items: const ['Male', 'Female', 'Others'],
            onChanged: (value) {},
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Educational Details'),
          TextInput(
            labelText: 'School Name',
            prefixIcon: Icons.school_outlined,
            inputType: TextInputType.text,
            controller: schoolNameController,
            validator: (value) => validateRequiredInput(value, 'school name'),
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Academic Year',
            prefixIcon: Icons.calendar_month_outlined,
            items: getAcademicYears(
              previousYears: 2,
              futureYears: 5,
            ),
            onChanged: (value) {},
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Education Board',
            prefixIcon: Icons.library_books_outlined,
            items: const ['State Board', 'CBSE', 'ICSE', 'IG'],
            onChanged: (value) {},
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Standard',
            prefixIcon: Icons.class_outlined,
            items: const ['VII', 'VIII', 'IX', 'X', 'XI', 'XII'],
            onChanged: (value) {},
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Location Details'),
          TextInput(
            labelText: 'Address Line 1',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
            controller: addressLine1Controller,
            validator: (value) =>
                validateRequiredInput(value, 'address line 1'),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Address Line 2',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
            controller: addressLine2Controller,
            validator: (value) =>
                validateRequiredInput(value, 'address line 2'),
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
            validator: (value) => validateRequiredInput(value, 'city'),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'State',
            prefixIcon: Icons.map_outlined,
            inputType: TextInputType.text,
            controller: stateController,
            validator: (value) => validateRequiredInput(value, 'state'),
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: 'Country',
            prefixIcon: Icons.public_outlined,
            inputType: TextInputType.text,
            controller: countryController,
            validator: (value) => validateRequiredInput(value, 'country'),
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
            onChanged: (value) {},
            validator: validateDropdownValue,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: "Parent's Phone Number",
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            controller: parentPhoneController,
            validator: validatePhoneNumber,
          ),
          const SizedBox(height: 10),
          TextInput(
            labelText: "Parent's Email Address",
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
            controller: parentEmailController,
            validator: validateEmail,
          ),
          const SizedBox(height: 50),
          PrimaryButton(
            title: 'Enroll',
            onPressed: submitFormHandler,
          ),
        ],
      ),
    );
  }
}
