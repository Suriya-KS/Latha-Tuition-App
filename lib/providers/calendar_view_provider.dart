import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CalendarView {
  selectedDate,
  firstDate,
  lastDate,
  startTime,
  endTime,
  activeToggle,
}

enum CalendarViewToggles {
  attendance,
  tests,
}

final initialState = {
  CalendarView.selectedDate: DateTime.now(),
  CalendarView.firstDate:
      DateTime.now().subtract(const Duration(days: 365 * 2)),
  CalendarView.lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
  CalendarView.activeToggle: CalendarViewToggles.attendance
};

class CalendarViewNotifier extends StateNotifier<Map<CalendarView, dynamic>> {
  CalendarViewNotifier() : super(initialState);

  void setSelectedDate(DateTime date) {
    state = {
      ...state,
      CalendarView.selectedDate: date,
    };
  }

  void changeActiveToggle(CalendarViewToggles toggle) {
    state = {
      ...state,
      CalendarView.activeToggle: toggle,
    };
  }
}

final calendarViewProvider =
    StateNotifierProvider<CalendarViewNotifier, Map<CalendarView, dynamic>>(
  (ref) => CalendarViewNotifier(),
);
