import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';

class ScrollableImageContent extends StatelessWidget {
  const ScrollableImageContent({
    super.key,
    required this.screenHeight,
    required this.totalScreenPadding,
    required this.imagePath,
    required this.title,
    required this.descriiption,
    required this.child,
  });

  final Widget child;
  final double screenHeight;
  final double totalScreenPadding;
  final String imagePath;
  final String title;
  final String descriiption;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(screenPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - totalScreenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  imagePath,
                  height: screenHeight * 0.25,
                ),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  TitleText(title: title),
                  const SizedBox(height: 10),
                  Text(descriiption),
                ],
              ),
              const SizedBox(height: 30),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
