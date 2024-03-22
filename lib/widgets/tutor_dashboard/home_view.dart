import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/helper_functions.dart';
import 'package:latha_tuition_app/providers/loading_provider.dart';
import 'package:latha_tuition_app/providers/animated_drawer_provider.dart';
import 'package:latha_tuition_app/widgets/utilities/loading_overlay.dart';
import 'package:latha_tuition_app/widgets/utilities/side_drawer.dart';
import 'package:latha_tuition_app/widgets/app_bar/scrollable_image_app_bar.dart';
import 'package:latha_tuition_app/widgets/tutor_dashboard/home_contents.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final animatedDrawerData = ref.watch(animatedDrawerProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Stack(
        children: [
          const SideDrawer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                animatedDrawerData[AnimatedDrawer.isOpen] ? 30 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 10,
                  blurRadius: 30,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: animatedDrawerData[AnimatedDrawer.isOpen]
                ? Clip.hardEdge
                : Clip.none,
            transform: Matrix4.translationValues(
              animatedDrawerData[AnimatedDrawer.xOffset],
              animatedDrawerData[AnimatedDrawer.yOffset],
              0,
            )
              ..scale(animatedDrawerData[AnimatedDrawer.scale])
              ..rotateZ(animatedDrawerData[AnimatedDrawer.rotateZ]),
            child: CustomScrollView(
              slivers: [
                ScrollableImageAppBar(
                  title: formatName('Tutor Name'),
                  screenHeight: screenHeight,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) => const HomeContents(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
