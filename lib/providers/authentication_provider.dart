import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Authentication {
  studentID,
  tutorID,
}

final initialState = {
  Authentication.studentID: null,
  Authentication.tutorID: null,
};

class AuthenticationNotifier
    extends StateNotifier<Map<Authentication, dynamic>> {
  AuthenticationNotifier() : super(initialState);

  void setStudentID(String studentID) {
    state = {
      ...state,
      Authentication.studentID: studentID,
    };
  }

  void setTutorID(String tutorID) {
    state = {
      ...state,
      Authentication.tutorID: tutorID,
    };
  }

  void clearStudentID() {
    state = {
      ...state,
      Authentication.studentID: null,
    };
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, Map<Authentication, dynamic>>(
  (ref) => AuthenticationNotifier(),
);
