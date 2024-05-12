import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageWithCaption extends StatelessWidget {
  const ImageWithCaption({
    required this.imagePath,
    required this.description,
    this.enableBottomPadding = true,
    this.imageHeight = 120,
    super.key,
  });

  final String imagePath;
  final String description;
  final bool enableBottomPadding;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            imagePath,
            height: imageHeight,
          ),
          const SizedBox(height: 20),
          Text(description),
          if (enableBottomPadding) SizedBox(height: imageHeight),
        ],
      ),
    );
  }
}
