import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/text_input.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';

class StudentRegistrationForm extends StatelessWidget {
  const StudentRegistrationForm({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SubtitleText(subtitle: 'Personal Details'),
          const TextInput(
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            inputType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'Phone Number',
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'Email Address',
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Gender',
            prefixIcon: Icons.transgender_outlined,
            items: const ['Male', 'Female', 'Others'],
            onChanged: (value) {},
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Educational Details'),
          const TextInput(
            labelText: 'School Name',
            prefixIcon: Icons.school_outlined,
            inputType: TextInputType.text,
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
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Education Board',
            prefixIcon: Icons.library_books_outlined,
            items: const ['State Board', 'CBSE', 'ICSE', 'IG'],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Standard',
            prefixIcon: Icons.class_outlined,
            items: const ['VII', 'VIII', 'IX', 'X', 'XI', 'XII'],
            onChanged: (value) {},
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: 'Location Details'),
          const TextInput(
            labelText: 'Address Line 1',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'Address Line 2',
            prefixIcon: Icons.home_outlined,
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'Pincode',
            prefixIcon: Icons.location_on_outlined,
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'City',
            prefixIcon: Icons.location_city_outlined,
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'State',
            prefixIcon: Icons.map_outlined,
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: 'Country',
            prefixIcon: Icons.public_outlined,
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 50),
          const SubtitleText(subtitle: "Parent's Details"),
          const TextInput(
            labelText: "Parent's Name",
            prefixIcon: Icons.group_outlined,
            inputType: TextInputType.name,
          ),
          const SizedBox(height: 10),
          DropdownInput(
            labelText: 'Parental Role',
            prefixIcon: Icons.family_restroom_outlined,
            items: const ['Father', 'Mother', 'Guardian'],
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: "Parent's Phone Number",
            prefixText: '+91 ',
            prefixIcon: Icons.phone_outlined,
            inputType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          const TextInput(
            labelText: "Parent's Email Address",
            prefixIcon: Icons.mail_outlined,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 50),
          const PrimaryButton(title: 'Enroll'),
        ],
      ),
    );
  }
}
