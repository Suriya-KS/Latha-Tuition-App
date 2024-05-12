import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackSheet {
  testName,
  totalMarks,
  batchName,
  startTime,
  endTime,
  activeToggle,
  batchNames,
  selectedAttendanceID,
  selectedTestMarksID,
  isBatchNameEditable,
}

enum TrackSheetToggles {
  attendance,
  tests,
}

final initialState = {
  TrackSheet.testName: null,
  TrackSheet.totalMarks: 100.00,
  TrackSheet.batchName: null,
  TrackSheet.startTime: null,
  TrackSheet.endTime: null,
  TrackSheet.activeToggle: TrackSheetToggles.attendance,
  TrackSheet.batchNames: <String>[],
  TrackSheet.selectedAttendanceID: null,
  TrackSheet.selectedTestMarksID: null,
  TrackSheet.isBatchNameEditable: true,
};

class TrackSheetNotifier extends StateNotifier<Map<TrackSheet, dynamic>> {
  TrackSheetNotifier() : super(initialState);

  void loadBatches(List<String> batchNames) {
    state = {
      ...state,
      TrackSheet.batchNames: batchNames,
    };
  }

  void setBatchName(String batchName) {
    state = {
      ...state,
      TrackSheet.batchName: batchName,
    };
  }

  void setTime(TimeOfDay startTime, TimeOfDay endTime) {
    state = {
      ...state,
      TrackSheet.startTime: startTime,
      TrackSheet.endTime: endTime,
    };
  }

  void setTestName(String testName) {
    state = {
      ...state,
      TrackSheet.testName: testName,
    };
  }

  void setTotalMarks(num? totalMarks) {
    if (totalMarks == null) return;

    state = {
      ...state,
      TrackSheet.totalMarks: totalMarks,
    };
  }

  void changeActiveToggle(int index) {
    if (index == 0) {
      state = {
        ...state,
        TrackSheet.activeToggle: TrackSheetToggles.attendance,
      };
    }

    if (index == 1) {
      state = {
        ...state,
        TrackSheet.activeToggle: TrackSheetToggles.tests,
      };
    }
  }

  void setSelectedAttendanceID(String? selectedAttendanceID) {
    state = {
      ...state,
      TrackSheet.selectedAttendanceID: selectedAttendanceID,
    };
  }

  void setSelectedTestMarksID(String? selectedTestMarksID) {
    state = {
      ...state,
      TrackSheet.selectedTestMarksID: selectedTestMarksID,
    };
  }

  void setIsBatchNameEditable(bool isBatchNameEditable) {
    state = {
      ...state,
      TrackSheet.isBatchNameEditable: isBatchNameEditable,
    };
  }
}

final trackSheetProvider =
    StateNotifierProvider<TrackSheetNotifier, Map<TrackSheet, dynamic>>(
  (ref) => TrackSheetNotifier(),
);
