import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class TitleIconActionTile extends StatelessWidget {
  const TitleIconActionTile({
    required this.title,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.onPressAndSwipe,
    this.iconColor,
    super.key,
  });

  final String title;
  final IconData icon;
  final int index;
  final void Function() onTap;
  final void Function(int) onPressAndSwipe;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: screenPadding,
          right: 10,
        ),
        child: Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (dismissDirection) => onPressAndSwipe(index),
          key: UniqueKey(),
          background: Container(
            color: iconColor,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.background,
              ),
              const SizedBox(width: 25),
            ]),
          ),
          child: ListTile(
            title: Text(title),
            trailing: IconButton(
              onPressed: () => onPressAndSwipe(index),
              icon: Icon(
                icon,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
