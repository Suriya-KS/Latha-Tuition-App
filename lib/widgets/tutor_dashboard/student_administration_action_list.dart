import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/cards/box_card.dart';

class StudentAdministrationActionList extends StatelessWidget {
  const StudentAdministrationActionList({super.key});

  void studentSearchTapHandler() {}

  void studentApprovalTapHandler() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: screenPadding),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BoxCard(
                title: 'Student Search',
                image: searchImage,
                onTap: () => studentSearchTapHandler(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BoxCard(
                title: 'Student Approval',
                image: pendingApprovalImage,
                onTap: studentApprovalTapHandler,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
