import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/form_validation_functions.dart';
import 'package:latha_tuition_app/providers/tutor_search_provider.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_student_information.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/dropdown_input.dart';
import 'package:latha_tuition_app/widgets/form_inputs/search_input.dart';

class TutorStudentSearchSheet extends ConsumerStatefulWidget {
  const TutorStudentSearchSheet({super.key});

  @override
  ConsumerState<TutorStudentSearchSheet> createState() =>
      _TutorStudentSearchSheetState();
}

class _TutorStudentSearchSheetState
    extends ConsumerState<TutorStudentSearchSheet> {
  late List<List<String>> studentIDsAndNamesList;

  List<List<String>> getStudentIDsAndNamesList(
      List<Map<String, dynamic>> studentsDetails) {
    final studentIDsAndNamesList = studentsDetails
        .map((studentDetails) => [
              studentDetails['id'].toString(),
              studentDetails['name'].toString(),
            ])
        .toList();

    return studentIDsAndNamesList;
  }

  void batchChangeHandler(String? batchName) {
    if (batchName == null) return;

    final studentsDetails =
        ref.read(tutorSearchProvider)[TutorSearch.studentsDetails];

    final filteredStudentsDetails = studentsDetails
        .where((studentDetails) => studentDetails['batch'] == batchName)
        .toList();

    setState(() {
      studentIDsAndNamesList = getStudentIDsAndNamesList(
        filteredStudentsDetails,
      );
    });
  }

  void studentSelectHandler(
    BuildContext context,
    List<String> option,
    Function onSelected,
  ) {
    onSelected(option);

    ref.read(tutorSearchProvider.notifier).setSelectedStudentID(option[0]);

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
  void initState() {
    super.initState();

    final studentsDetails =
        ref.read(tutorSearchProvider)[TutorSearch.studentsDetails];

    studentIDsAndNamesList = getStudentIDsAndNamesList(studentsDetails);
  }

  @override
  Widget build(BuildContext context) {
    final tutorSearchData = ref.watch(tutorSearchProvider);

    return Column(
      children: [
        const TitleText(title: 'Search Student'),
        const SizedBox(height: 30),
        Column(
          children: [
            DropdownInput(
              labelText: 'Batch Name',
              prefixIcon: Icons.groups_outlined,
              items: tutorSearchData[TutorSearch.batchNames],
              onChanged: batchChangeHandler,
              validator: (value) => validateRequiredInput(
                value,
                'a',
                'batch name',
              ),
            ),
            const SizedBox(height: 10),
            SearchInput(
              labelText: 'Student Name',
              prefixIcon: Icons.person_outline,
              items: studentIDsAndNamesList,
              onChanged: studentSelectHandler,
            ),
            const SizedBox(height: screenPadding),
          ],
        ),
      ],
    );
  }
}
