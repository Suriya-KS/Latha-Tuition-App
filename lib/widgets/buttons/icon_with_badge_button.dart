import 'package:flutter/material.dart';

class IconWithBadgeButton extends StatelessWidget {
  const IconWithBadgeButton({
    required this.icon,
    required this.onPressed,
    this.badgeCount = 0,
    super.key,
  });

  final IconData icon;
  final void Function() onPressed;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        if (badgeCount != 0)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
