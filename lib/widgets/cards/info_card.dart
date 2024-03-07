import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    required this.icon,
    required this.children,
    this.iconPosition = 'left',
    this.isClickable = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final List<Widget> children;
  final String iconPosition;
  final bool isClickable;
  final void Function()? onTap;

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
          left: widget.iconPosition == 'left' ? -iconWidth * 0.5 : null,
          right: widget.iconPosition == 'right' ? -iconWidth * 0.5 : null,
          child: Container(
            height: 36,
            width: 36,
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
            child: IconButton(
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: widget.isClickable ? widget.onTap : null,
              icon: Icon(
                widget.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
