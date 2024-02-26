import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/utilities/dummy_data.dart';
import 'package:latha_tuition_app/widgets/texts/text_with_icon.dart';
import 'package:latha_tuition_app/widgets/cards/info_card.dart';

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    IconData genderIcon;

    if (dummyStudentDetails['gender'] == 'Male') {
      genderIcon = Icons.male_outlined;
    } else if (dummyStudentDetails['gender'] == 'Female') {
      genderIcon = Icons.female_outlined;
    } else {
      genderIcon = Icons.transgender_outlined;
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(screenPadding),
          child: Column(
            children: [
              InfoCard(
                icon: Icons.person_outline,
                children: [
                  TextWithIcon(
                    icon: Icons.phone_outlined,
                    text: dummyStudentDetails['phoneNumber'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.mail_outline,
                    text: dummyStudentDetails['emailAddress'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: genderIcon,
                    text: dummyStudentDetails['gender'],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InfoCard(
                icon: Icons.school_outlined,
                children: [
                  TextWithIcon(
                    icon: Icons.apartment_outlined,
                    text: dummyStudentDetails['schoolName'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.calendar_month_outlined,
                    text: dummyStudentDetails['academicYear'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.menu_book_outlined,
                    text: dummyStudentDetails['educationBoard'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.class_outlined,
                    text: dummyStudentDetails['standard'],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InfoCard(
                icon: Icons.location_on_outlined,
                children: [
                  Text(
                    '${dummyStudentDetails['addressLine1']}, ${dummyStudentDetails['addressLine2']}, \n${dummyStudentDetails['city']} - ${dummyStudentDetails['pincode']}, \n${dummyStudentDetails['state']}, ${dummyStudentDetails['country']}.',
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InfoCard(
                icon: Icons.family_restroom_outlined,
                children: [
                  TextWithIcon(
                    icon: Icons.person_outline,
                    text: dummyStudentDetails['parentsName'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.group_outlined,
                    text: dummyStudentDetails['parentalRole'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.phone_outlined,
                    text: dummyStudentDetails['parentsPhoneNumber'],
                  ),
                  const SizedBox(height: 5),
                  TextWithIcon(
                    icon: Icons.mail_outline,
                    text: dummyStudentDetails['parentsEmailAddress'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
