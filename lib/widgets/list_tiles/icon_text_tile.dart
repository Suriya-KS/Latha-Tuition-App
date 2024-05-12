import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class IconTextTile extends StatelessWidget {
  const IconTextTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final Widget description;
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: icon,
          subtitle: description,
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
          ),
        ),
      ),
    );
  }
}
