import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_student_information.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/search_input.dart';

class TutorStudentSearchSheet extends StatefulWidget {
  const TutorStudentSearchSheet({super.key});

  @override
  State<TutorStudentSearchSheet> createState() =>
      _TutorStudentSearchSheetState();
}

class _TutorStudentSearchSheetState extends State<TutorStudentSearchSheet> {
  void studentSelectHandler(
    BuildContext context,
    String option,
    Function onSelected,
  ) {
    onSelected(option);

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const TutorStudentInformationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(title: 'Search Student'),
        const SizedBox(height: 30),
        Column(
          children: [
            DropdownInput(
              labelText: 'Batch Name',
              prefixIcon: Icons.groups_outlined,
              items: dummyBatchNames,
              onChanged: (value) {},
              validator: (value) =>
                  validateRequiredInput(value, 'a', 'batch name'),
            ),
            const SizedBox(height: 10),
            SearchInput(
              labelText: 'Student Name',
              prefixIcon: Icons.person_outline,
              items: dummyStudentNames,
              onChanged: studentSelectHandler,
            ),
            const SizedBox(height: screenPadding),
          ],
        ),
      ],
    );
  }
}
