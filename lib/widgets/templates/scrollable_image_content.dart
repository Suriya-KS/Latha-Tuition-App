import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/texts/title_text.dart';

class ScrollableImageContent extends StatelessWidget {
  const ScrollableImageContent({
    super.key,
    required this.screenSize,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.child,
    this.imageHeightFactor,
    this.imageAlignment,
  });

  final MediaQueryData screenSize;
  final String imagePath;
  final String title;
  final String description;
  final Widget child;
  final double? imageHeightFactor;
  final Alignment? imageAlignment;

  @override
  Widget build(BuildContext context) {
    final screenHeight = screenSize.size.height;
    final totalScreenPadding =
        screenSize.padding.top + screenSize.padding.bottom + screenPadding * 2;

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
              Column(
                children: [
                  Align(
                    alignment: imageAlignment ?? Alignment.centerLeft,
                    child: SvgPicture.asset(
                      imagePath,
                      height: screenHeight * (imageHeightFactor ?? 0.25),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(title: title),
                      const SizedBox(height: 10),
                      Text(description),
                    ],
                  ),
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
