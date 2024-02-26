import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/search_input.dart';

class StudentSearchSheet extends StatefulWidget {
  const StudentSearchSheet({super.key});

  @override
  State<StudentSearchSheet> createState() => _StudentSearchSheetState();
}

class _StudentSearchSheetState extends State<StudentSearchSheet> {
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
            ),
            const SizedBox(height: screenPadding),
          ],
        ),
      ],
    );
  }
}
