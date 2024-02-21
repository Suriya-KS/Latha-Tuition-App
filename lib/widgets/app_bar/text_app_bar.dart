import 'package:flutter/material.dart';

class TextAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TextAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
