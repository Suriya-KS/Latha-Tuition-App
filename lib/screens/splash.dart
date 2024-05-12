import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isDarkMode = false;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late AnimationController titleAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  late Animation<double> titleAnimation = CurvedAnimation(
    parent: titleAnimationController,
    curve: Curves.easeIn,
  );

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

    titleAnimationController.forward();

    titleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        titleAnimationController.dispose();
      }
    });
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(screenPadding),
                child: Chewie(
                  controller: chewieController,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.7,
            child: FadeTransition(
              opacity: titleAnimation,
              child: const Text(
                'Latha Tuition',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
