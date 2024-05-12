import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TutorSearch {
  batchNames,
  fullStudentDetails,
  studentsDetails,
  selectedStudentID,
}

final initialState = {
  TutorSearch.batchNames: [],
  TutorSearch.fullStudentDetails: [],
  TutorSearch.studentsDetails: [],
  TutorSearch.selectedStudentID: null,
};

class TutorSearchNotifier extends StateNotifier<Map<TutorSearch, dynamic>> {
  TutorSearchNotifier() : super(initialState);

  void setBatchNames(List<String> batchNames) {
    state = {
      ...state,
      TutorSearch.batchNames: batchNames,
    };
  }

  void setFullStudentDetails(List<Map<String, dynamic>> fullStudentDetails) {
    state = {
      ...state,
      TutorSearch.fullStudentDetails: fullStudentDetails,
    };
  }

  void setStudentsDetails(List<Map<String, dynamic>> studentsDetails) {
    state = {
      ...state,
      TutorSearch.studentsDetails: studentsDetails,
    };
  }

  void setSelectedStudentID(String studentID) {
    state = {
      ...state,
      TutorSearch.selectedStudentID: studentID,
    };
  }
}

final tutorSearchProvider =
    StateNotifierProvider<TutorSearchNotifier, Map<TutorSearch, dynamic>>(
  (ref) => TutorSearchNotifier(),
);
