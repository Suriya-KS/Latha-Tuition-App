import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/modal_bottom_sheet.dart';
import 'package:latha_tuition_app/widgets/cards/box_card.dart';
import 'package:latha_tuition_app/widgets/bottom_sheets/student_search_sheet.dart';

class StudentAdministrationActionList extends StatelessWidget {
  const StudentAdministrationActionList({super.key});

  void studentSearchTapHandler(BuildContext context) {
    modalBottomSheet(
      context,
      const StudentSearchSheet(),
    );
  }

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
                onTap: () => studentSearchTapHandler(context),
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
