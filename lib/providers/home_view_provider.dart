import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeView {
  activeToggle,
  upcomingClasses,
  scheduledTests,
}

enum HomeViewToggles {
  classes,
  tests,
}

final initialState = {
  HomeView.activeToggle: HomeViewToggles.classes,
  HomeView.upcomingClasses: <Map<String, dynamic>>[],
  HomeView.scheduledTests: <Map<String, dynamic>>[],
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

  void setUpcomingClasses(List<Map<String, dynamic>> upcomingClasses) {
    state = {
      ...state,
      HomeView.upcomingClasses: upcomingClasses,
    };
  }

  void setScheduledTests(List<Map<String, dynamic>> scheduledTests) {
    state = {
      ...state,
      HomeView.scheduledTests: scheduledTests,
    };
  }
}

final homeViewProvider =
    StateNotifierProvider<HomeViewNotifier, Map<HomeView, dynamic>>(
  (ref) => HomeViewNotifier(),
);
