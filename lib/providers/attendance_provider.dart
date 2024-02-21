import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Attendance {
  list,
}

enum AttendanceStatus {
  present,
  absent,
}

final initialState = {
  Attendance.list: [],
};

class AttendanceNotifier extends StateNotifier<Map<Attendance, dynamic>> {
  AttendanceNotifier() : super(initialState);

  void startAttendanceTracker(int length) {
    state = {
      ...state,
      Attendance.list: List.filled(length, AttendanceStatus.present),
    };
  }

  void trackAttendance(int index, AttendanceStatus status) {
    if (index > state[Attendance.list].length || index < 0) return;

    final attendanceList = List<AttendanceStatus>.from(state[Attendance.list]);

    attendanceList[index] = status;

    state = {
      ...state,
      Attendance.list: attendanceList,
    };
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, Map<Attendance, dynamic>>(
  (ref) => AttendanceNotifier(),
);
