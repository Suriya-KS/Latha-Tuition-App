import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoxCard extends StatelessWidget {
  const BoxCard({
    required this.title,
    required this.image,
    required this.onTap,
    super.key,
  });

  final String title;
  final String image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      surfaceTintColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    image,
                    width: screenWidth * 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
