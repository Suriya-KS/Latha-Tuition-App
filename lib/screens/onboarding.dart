import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:latha_tuition_app/widgets/onboarding/onboarding_page_list.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final lastPageIndex = 2;

  int currentPageIndex = 0;

  late LiquidController liquidController;

  void pageChangeHandler(activePageIndex) {
    setState(() {
      currentPageIndex = activePageIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    liquidController = LiquidController();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final navigationBarHeight = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          OnboardingPageList(
            liquidController: liquidController,
            currentPageIndex: currentPageIndex,
            lastPageIndex: lastPageIndex,
            onPageChange: pageChangeHandler,
          ),
          currentPageIndex < lastPageIndex
              ? Positioned(
                  top: statusBarHeight,
                  right: 0,
                  child: TextButton(
                    onPressed: () =>
                        liquidController.jumpToPage(page: lastPageIndex),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.only(bottom: navigationBarHeight + 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSmoothIndicator(
                activeIndex: currentPageIndex,
                count: lastPageIndex + 1,
                effect: ScrollingDotsEffect(
                  activeDotColor: Theme.of(context).colorScheme.onBackground,
                  dotColor: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.2),
                  activeDotScale: 1.6,
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
