import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceNotifier extends StateNotifier<List<dynamic>> {
  AttendanceNotifier() : super([]);

  void setInitialState(List<dynamic> initialState) {
    state = initialState;
  }

  void trackAttendance(int index, String status) {
    if (index > state.length || index < 0) return;

    final attendanceList = List.from(state);

    attendanceList[index]['attendanceStatus'] = status;

    state = [...attendanceList];
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, List<dynamic>>(
  (ref) => AttendanceNotifier(),
);
