import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/app_bar/text_app_bar.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/form_inputs/toggle_input.dart';
import 'package:latha_tuition_app/widgets/student_information.dart/personal_details_view.dart';

class StudentInformationScreen extends StatefulWidget {
  const StudentInformationScreen({super.key});

  @override
  State<StudentInformationScreen> createState() =>
      _StudentInformationScreenState();
}

class _StudentInformationScreenState extends State<StudentInformationScreen> {
  static const pages = [
    PersonalDetailsView(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  late int index;

  void toggleHandler(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar(title: studentInformationScreenTitles[index]),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: SubtitleText(
                subtitle: 'Student Name',
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: Align(
                alignment: Alignment.center,
                child: ToggleInput(
                  onToggle: toggleHandler,
                  children: const [
                    Icon(Icons.person_outline),
                    Icon(Icons.groups_outlined),
                    Icon(Icons.assignment_outlined),
                    Icon(Icons.currency_rupee_outlined),
                    Icon(Icons.message_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            pages[index],
          ],
        ),
      ),
    );
  }
}
