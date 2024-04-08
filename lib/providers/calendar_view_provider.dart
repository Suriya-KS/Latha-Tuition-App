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

final currentDate = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

final initialState = {
  CalendarView.selectedDate: currentDate,
  CalendarView.firstDate: currentDate.subtract(
    const Duration(days: 365 * 2),
  ),
  CalendarView.lastDate: currentDate.add(
    const Duration(days: 365 * 2),
  ),
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

  void changeActiveToggle(int index) {
    if (index == 0) {
      state = {
        ...state,
        CalendarView.activeToggle: CalendarViewToggles.attendance,
      };
    }

    if (index == 1) {
      state = {
        ...state,
        CalendarView.activeToggle: CalendarViewToggles.tests,
      };
    }
  }
}

final calendarViewProvider =
    StateNotifierProvider<CalendarViewNotifier, Map<CalendarView, dynamic>>(
  (ref) => CalendarViewNotifier(),
);
