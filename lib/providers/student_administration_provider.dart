import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/utilities/dummy_data.dart';

enum StudentAdministration {
  batches,
  educationBoards,
  standards,
  enabledStandards,
}

final initialState = {
  StudentAdministration.batches: dummyBatchNames,
  StudentAdministration.educationBoards: dummyEducationBoards,
  StudentAdministration.standards: dummyStandards,
  StudentAdministration.enabledStandards: [],
};

class StudentAdministrationNotifier
    extends StateNotifier<Map<StudentAdministration, dynamic>> {
  StudentAdministrationNotifier() : super(initialState);

  void addBatch(String batchName, {int? index}) {
    final batches = [...state[StudentAdministration.batches]];

    if (index == null) {
      batches.add(batchName);
    } else {
      batches.insert(index, batchName);
    }

    state = {
      ...state,
      StudentAdministration.batches: batches,
    };
  }

  void updateBatch(String batchName, int index) {
    final batches = [...state[StudentAdministration.batches]];

    batches[index] = batchName;

    state = {
      ...state,
      StudentAdministration.batches: batches,
    };
  }

  void deleteBatch(int index) {
    final batches = [...state[StudentAdministration.batches]];

    batches.removeAt(index);

    state = {
      ...state,
      StudentAdministration.batches: batches,
    };
  }

  void addEducationBoard(String educationBoard, {int? index}) {
    final batches = [...state[StudentAdministration.educationBoards]];

    if (index == null) {
      batches.add(educationBoard);
    } else {
      batches.insert(index, educationBoard);
    }

    state = {
      ...state,
      StudentAdministration.educationBoards: batches,
    };
  }

  void updateEducationBoard(String educationBoard, int index) {
    final batches = [...state[StudentAdministration.educationBoards]];

    batches[index] = educationBoard;

    state = {
      ...state,
      StudentAdministration.educationBoards: batches,
    };
  }

  void deleteEducationBoard(int index) {
    final batches = [...state[StudentAdministration.educationBoards]];

    batches.removeAt(index);

    state = {
      ...state,
      StudentAdministration.educationBoards: batches,
    };
  }

  void updateEnabledStandards(String standard, bool isEnabled) {
    final enabledStandards = [...state[StudentAdministration.enabledStandards]];

    if (isEnabled && !enabledStandards.contains(standard)) {
      enabledStandards.add(standard);
    } else if (!isEnabled) {
      enabledStandards.remove(standard);
    }

    state = {
      ...state,
      StudentAdministration.enabledStandards: enabledStandards,
    };
  }
}

final studentAdministrationProvider = StateNotifierProvider<
    StudentAdministrationNotifier, Map<StudentAdministration, dynamic>>(
  (ref) => StudentAdministrationNotifier(),
);
