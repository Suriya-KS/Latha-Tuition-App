import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/screens/configure_batches.dart';
import 'package:latha_tuition_app/screens/configure_standards.dart';
import 'package:latha_tuition_app/screens/configure_education_boards.dart';
import 'package:latha_tuition_app/widgets/texts/subtitle_text.dart';
import 'package:latha_tuition_app/widgets/cards/icon_text_tile.dart';

class StudentAdministrationConfigurations extends StatelessWidget {
  const StudentAdministrationConfigurations({super.key});

  void navigateToConfigureBatchesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureBatchesScreen(),
      ),
    );
  }

  void navigateToConfigureStandardsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureStandardsScreen(),
      ),
    );
  }

  void navigateToConfigureEducationBoardsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigureEducationBoards(),
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
          description: 'Create and manage batches',
          icon: Icons.groups_outlined,
          onTap: () => navigateToConfigureBatchesScreen(context),
        ),
        IconTextTile(
          title: 'Standards',
          description: 'Customize the allowed standards',
          icon: Icons.assignment_outlined,
          onTap: () => navigateToConfigureStandardsScreen(context),
        ),
        IconTextTile(
          title: 'Education Boards',
          description: 'Specify the allowed education boards',
          icon: Icons.school_outlined,
          onTap: () => navigateToConfigureEducationBoardsScreen(context),
        ),
      ],
    );
  }
}
