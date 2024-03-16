import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Admission {
  studentDetails,
}

final initialState = {
  Admission.studentDetails: null,
};

class AdmissionNotifier extends StateNotifier<Map<Admission, dynamic>> {
  AdmissionNotifier() : super(initialState);

  void setStudentDetails(Map<String, dynamic> studentDetails) {
    state = {
      ...state,
      Admission.studentDetails: studentDetails,
    };
  }
}

final admissionProvider =
    StateNotifierProvider<AdmissionNotifier, Map<Admission, dynamic>>(
  (ref) => AdmissionNotifier(),
);
