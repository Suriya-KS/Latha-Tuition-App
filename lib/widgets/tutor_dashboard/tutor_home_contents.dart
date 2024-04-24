import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/utilities/image_with_caption.dart';

class TutorHomeContents extends StatelessWidget {
  const TutorHomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(screenPadding),
      child: Column(
        children: [
          Text('Upcoming Classes & Scheduled Tests'),
          SizedBox(height: 20),
          ImageWithCaption(
            imagePath: placeholderImage,
            description: 'Under construction, coming soon!',
            useMaxHeight: false,
            imageHeight: 200,
          ),
        ],
      ),
    );
  }
}
