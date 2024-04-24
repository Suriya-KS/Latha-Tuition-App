import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class ImageWithCaption extends StatelessWidget {
  const ImageWithCaption({
    required this.imagePath,
    required this.description,
    this.useMaxHeight = true,
    this.imageHeight = 120,
    super.key,
  });

  final String imagePath;
  final String description;
  final bool useMaxHeight;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    if (!useMaxHeight) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SvgPicture.asset(
              imagePath,
              height: imageHeight,
            ),
            const SizedBox(height: 20),
            Text(description),
          ],
        ),
      );
    }

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              notFoundImage,
              height: imageHeight,
            ),
            const SizedBox(height: 20),
            Text(description),
            SizedBox(height: imageHeight),
          ],
        ),
      ),
    );
  }
}
