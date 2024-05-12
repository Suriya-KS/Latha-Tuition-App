import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AnimatedDrawer {
  isOpen,
  xOffset,
  yOffset,
  scale,
  rotateZ,
}

final initialState = {
  AnimatedDrawer.isOpen: false,
  AnimatedDrawer.xOffset: 0.0,
  AnimatedDrawer.yOffset: 0.0,
  AnimatedDrawer.scale: 1.0,
  AnimatedDrawer.rotateZ: 0.0,
};

class AnimatedDrawerNotifier
    extends StateNotifier<Map<AnimatedDrawer, dynamic>> {
  AnimatedDrawerNotifier() : super(initialState);

  void toggleAnimatedDrawer() {
    if (state[AnimatedDrawer.isOpen]) {
      state = initialState;

      return;
    }

    state = {
      ...state,
      AnimatedDrawer.isOpen: true,
      AnimatedDrawer.xOffset: 290.0,
      AnimatedDrawer.yOffset: 80.0,
      AnimatedDrawer.scale: 0.8,
      AnimatedDrawer.rotateZ: -50.0,
    };
  }

  void closeAnimatedDrawer() {
    state = initialState;
  }
}

final animatedDrawerProvider =
    StateNotifierProvider<AnimatedDrawerNotifier, Map<AnimatedDrawer, dynamic>>(
  (ref) => AnimatedDrawerNotifier(),
);
