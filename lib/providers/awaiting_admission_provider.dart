import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AwaitingAdmission {
  studentID,
  parentContext,
  parentRef,
}

final initialState = {
  AwaitingAdmission.studentID: null,
  AwaitingAdmission.parentContext: null,
  AwaitingAdmission.parentRef: null,
};

class AwaitingAdmissionNotifier
    extends StateNotifier<Map<AwaitingAdmission, dynamic>> {
  AwaitingAdmissionNotifier() : super(initialState);

  Future<void> loadStudentID() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final studentID = sharedPreferences.getString(
      AwaitingAdmission.studentID.toString(),
    );

    state = {
      ...state,
      AwaitingAdmission.studentID: studentID,
    };
  }

  Future<void> setStudentID(String studentID) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(
      AwaitingAdmission.studentID.toString(),
      studentID,
    );

    state = {
      ...state,
      AwaitingAdmission.studentID: studentID,
    };
  }

  void setParentContext(BuildContext context) {
    state = {
      ...state,
      AwaitingAdmission.parentContext: context,
    };
  }

  void setParentRef(WidgetRef ref) {
    state = {
      ...state,
      AwaitingAdmission.parentRef: ref,
    };
  }

  Future<void> clearData() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.clear();

    state = {
      ...state,
      AwaitingAdmission.studentID: null,
    };
  }
}

final awaitingAdmissionProvider = StateNotifierProvider<
    AwaitingAdmissionNotifier, Map<AwaitingAdmission, dynamic>>(
  (ref) => AwaitingAdmissionNotifier(),
);
