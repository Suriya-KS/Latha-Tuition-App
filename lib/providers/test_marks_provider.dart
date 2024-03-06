import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestMarksNotifier extends StateNotifier<List<dynamic>> {
  TestMarksNotifier() : super([]);

  void setInitialState(List<dynamic> initialState) {
    state = initialState;
  }
}

final testMarksProvider =
    StateNotifierProvider<TestMarksNotifier, List<dynamic>>(
  (ref) => TestMarksNotifier(),
);
