import 'package:flutter/material.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/widgets/templates/scrollable_image_content.dart';

class OfflineErrorScreen extends StatefulWidget {
  const OfflineErrorScreen({
    required this.onRetry,
    super.key,
  });

  final Future<void> Function(BuildContext) onRetry;

  @override
  State<OfflineErrorScreen> createState() => _OfflineErrorScreenState();
}

class _OfflineErrorScreenState extends State<OfflineErrorScreen> {
  bool isLoading = false;

  void retryHandler(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await widget.onRetry(context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollableImageContent(
        screenSize: MediaQuery.of(context),
        imagePath: Theme.of(context).brightness == Brightness.light
            ? noNetworkImage
            : noNetworkImageDark,
        imageHeightFactor: 0.6,
        imageAlignment: Alignment.center,
        title: 'Lost Network Connection',
        description: 'Check your network cables and retry',
        child: TextButton(
          onPressed: !isLoading ? () => retryHandler(context) : null,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_outlined),
              SizedBox(width: 5),
              Text('Retry'),
            ],
          ),
        ),
      ),
    );
  }
}
