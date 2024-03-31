import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StudentSearch {
  batchNames,
  fullStudentDetails,
  studentsDetails,
  selectedStudentID,
}

final initialState = {
  StudentSearch.batchNames: [],
  StudentSearch.fullStudentDetails: [],
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

  void setFullStudentDetails(List<Map<String, dynamic>> fullStudentDetails) {
    state = {
      ...state,
      StudentSearch.fullStudentDetails: fullStudentDetails,
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
