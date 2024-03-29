import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Authentication {
  studentID,
}

final initialState = {
  Authentication.studentID: null,
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
