import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_configure_batches.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_configure_standards.dart';
import 'package:latha_tuition_app/screens/tutor/tutor_configure_education_boards.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/list_tiles/icon_text_tile.dart';

class TutorStudentAdministrationConfigurations extends StatelessWidget {
  const TutorStudentAdministrationConfigurations({super.key});

  void navigateToTutorConfigureBatchesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorConfigureBatchesScreen(),
      ),
    );
  }

  void navigateToTutorConfigureStandardsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorConfigureStandardsScreen(),
      ),
    );
  }

  void navigateToTutorConfigureEducationBoardsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorConfigureEducationBoards(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: SubtitleText(subtitle: 'Configure'),
        ),
        const SizedBox(height: 10),
        IconTextTile(
          title: 'Batches',
          description: const Text('Create and manage batches'),
          icon: const Icon(Icons.groups_outlined),
          onTap: () => navigateToTutorConfigureBatchesScreen(context),
        ),
        IconTextTile(
          title: 'Standards',
          description: const Text('Customize the allowed standards'),
          icon: const Icon(Icons.assignment_outlined),
          onTap: () => navigateToTutorConfigureStandardsScreen(context),
        ),
        IconTextTile(
          title: 'Education Boards',
          description: const Text('Specify the allowed education boards'),
          icon: const Icon(Icons.school_outlined),
          onTap: () => navigateToTutorConfigureEducationBoardsScreen(context),
        ),
      ],
    );
  }
}
