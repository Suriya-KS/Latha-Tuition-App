import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.title,
    this.iconData,
    this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    super.key,
  });

  final String? title;
  final IconData? iconData;
  final void Function()? onPressed;
  final bool isOutlined;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: !isOutlined
            ? Theme.of(context).colorScheme.onBackground
            : Colors.transparent,
        foregroundColor: !isOutlined
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.error,
        side: isOutlined
            ? BorderSide(color: Theme.of(context).colorScheme.error)
            : BorderSide.none,
        elevation: 0,
      ),
      onPressed: onPressed ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 18,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? CircularProgressIndicator.adaptive(
                    backgroundColor: Theme.of(context).colorScheme.background,
                  )
                : Text(
                    title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
            if (title != null && iconData != null) const SizedBox(width: 10),
            if (iconData != null)
              Icon(
                iconData,
                size: 35,
              ),
          ],
        ),
      ),
    );
  }
}
