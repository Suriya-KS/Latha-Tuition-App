import 'package:flutter/material.dart';

class CardFloatingIcon extends StatefulWidget {
  const CardFloatingIcon({
    required this.icon,
    required this.color,
    this.iconPosition = 'left',
    this.isClickable = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String iconPosition;
  final bool isClickable;
  final void Function()? onTap;

  @override
  State<CardFloatingIcon> createState() => _CardFloatingIconState();
}

class _CardFloatingIconState extends State<CardFloatingIcon> {
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
    return Positioned(
      top: -iconHeight * 0.5,
      left: widget.iconPosition == 'left' ? -iconWidth * 0.5 : null,
      right: widget.iconPosition == 'right' ? -iconWidth * 0.5 : null,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          onPressed: widget.isClickable ? widget.onTap : null,
          icon: Icon(
            widget.icon,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
