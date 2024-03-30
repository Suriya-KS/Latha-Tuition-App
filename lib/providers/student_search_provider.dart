import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StudentSearch {
  batchNames,
  studentsDetails,
  selectedStudentID,
}

final initialState = {
  StudentSearch.batchNames: [],
  StudentSearch.studentsDetails: [],
  StudentSearch.selectedStudentID: null,
};

class StudentSearchNotifier extends StateNotifier<Map<StudentSearch, dynamic>> {
  StudentSearchNotifier() : super(initialState);

  void setBatchNames(List<String> batchNames) {
    state = {
      ...state,
      StudentSearch.batchNames: batchNames,
    };
  }

  void setStudentsDetails(List<Map<String, dynamic>> studentsDetails) {
    state = {
      ...state,
      StudentSearch.studentsDetails: studentsDetails,
    };
  }

  void setSelectedStudentID(String studentID) {
    state = {
      ...state,
      StudentSearch.selectedStudentID: studentID,
    };
  }
}

final studentSearchProvider =
    StateNotifierProvider<StudentSearchNotifier, Map<StudentSearch, dynamic>>(
  (ref) => StudentSearchNotifier(),
);
