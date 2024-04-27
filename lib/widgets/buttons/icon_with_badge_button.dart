import 'package:flutter/material.dart';

class IconWithBadgeButton extends StatelessWidget {
  const IconWithBadgeButton({
    required this.icon,
    required this.onPressed,
    this.badgeCount = 0,
    this.showBadgeMark = false,
    super.key,
  });

  final IconData icon;
  final void Function() onPressed;
  final int badgeCount;
  final bool showBadgeMark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        if (showBadgeMark || badgeCount != 0)
          Positioned(
            top: !showBadgeMark ? -3 : 3,
            right: !showBadgeMark ? -3 : 3,
            child: Container(
              height: !showBadgeMark ? 18 : 12,
              width: !showBadgeMark ? 18 : 12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: !showBadgeMark
                      ? Text(
                          badgeCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          )
      ],
    );
  }
}
