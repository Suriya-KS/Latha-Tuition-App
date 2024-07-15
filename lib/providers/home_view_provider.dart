import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeView {
  activeToggle,
}

enum HomeViewToggles {
  classes,
  tests,
}

final initialState = {
  HomeView.activeToggle: HomeViewToggles.classes,
};

class HomeViewNotifier extends StateNotifier<Map<HomeView, dynamic>> {
  HomeViewNotifier() : super(initialState);

  void changeActiveToggle(int index) {
    if (index == 0) {
      state = {
        ...state,
        HomeView.activeToggle: HomeViewToggles.classes,
      };
    }

    if (index == 1) {
      state = {
        ...state,
        HomeView.activeToggle: HomeViewToggles.tests,
      };
    }
  }
}

final homeViewProvider =
    StateNotifierProvider<HomeViewNotifier, Map<HomeView, dynamic>>(
  (ref) => HomeViewNotifier(),
);
