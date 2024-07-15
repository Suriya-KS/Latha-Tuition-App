import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/utilities/card_floating_icon.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    required this.icon,
    required this.children,
    this.iconPosition = 'left',
    this.isClickable = false,
    this.onTap,
    super.key,
  });

  final IconData? icon;
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
              if (widget.icon != null) const SizedBox(height: 10),
              ...widget.children,
            ],
          ),
        ),
        if (widget.icon != null)
          CardFloatingIcon(
            icon: widget.icon!,
            color: Theme.of(context).colorScheme.primary,
            iconPosition: widget.iconPosition,
            isClickable: widget.isClickable,
            onTap: widget.onTap,
          ),
      ],
    );
  }
}
