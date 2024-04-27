import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDarkMode = false;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  void loadControllers() {
    final videoDataSource =
        isDarkMode ? splashLoadingVideoDark : splashLoadingVideo;

    videoPlayerController = VideoPlayerController.asset(videoDataSource);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      allowPlaybackSpeedChanging: false,
      showControls: false,
    );
  }

  @override
  void initState() {
    super.initState();

    loadControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    loadControllers();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(screenPadding),
            child: Chewie(
              controller: chewieController,
            ),
          ),
        ),
      ),
    );
  }
}
