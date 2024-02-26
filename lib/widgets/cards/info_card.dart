import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    required this.icon,
    required this.children,
    super.key,
  });

  final IconData icon;
  final List<Widget> children;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  final GlobalKey iconKey = GlobalKey();

  double iconWidth = 24;
  double iconHeight = 24;

  void updateIconSize() {
    if (iconKey.currentContext != null) {
      RenderBox renderBox =
          iconKey.currentContext!.findRenderObject() as RenderBox;

      setState(() {
        iconWidth = renderBox.size.width;
        iconHeight = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (duration) => updateIconSize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ...widget.children,
            ],
          ),
        ),
        Positioned(
          top: -iconHeight * 0.5,
          left: -iconWidth * 0.5,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              key: iconKey,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
