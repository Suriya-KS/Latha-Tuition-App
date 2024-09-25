import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Schedule {
  batchNames,
  startTime,
  endTime,
  activeToggle,
}

enum ScheduleToggles {
  classes,
  tests,
}

final initialState = {
  Schedule.batchNames: <String>[],
  Schedule.startTime: null,
  Schedule.endTime: null,
  Schedule.activeToggle: ScheduleToggles.classes,
};

class ScheduleNotifier extends StateNotifier<Map<Schedule, dynamic>> {
  ScheduleNotifier() : super(initialState);

  void loadBatches(List<String> batchNames) {
    state = {
      ...state,
      Schedule.batchNames: batchNames,
    };
  }

  void changeActiveToggle(int index) {
    if (index == 0) {
      state = {
        ...state,
        Schedule.activeToggle: ScheduleToggles.classes,
      };
    }

    if (index == 1) {
      state = {
        ...state,
        Schedule.activeToggle: ScheduleToggles.tests,
      };
    }
  }
}

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, Map<Schedule, dynamic>>(
  (ref) => ScheduleNotifier(),
);
