import 'package:flutter/material.dart';

final List<Map<String, dynamic>> dummyAttendanceData = [
  {
    'batchName': 'Batch 1',
    'standard': 'XII',
    'startTime': const TimeOfDay(hour: 11, minute: 0),
    'endTime': const TimeOfDay(hour: 12, minute: 0),
  },
  {
    'batchName': 'Batch 2',
    'standard': 'VIII',
    'startTime': const TimeOfDay(hour: 14, minute: 0),
    'endTime': const TimeOfDay(hour: 17, minute: 0),
  },
];

final List<Map<String, dynamic>> dummyTestMarksData = [
  {
    'testName': 'Test Name 1',
    'batchName': 'Batch 2',
    'standard': 'XI',
    'startTime': const TimeOfDay(hour: 8, minute: 0),
    'endTime': const TimeOfDay(hour: 10, minute: 0),
  },
  {
    'testName': 'Test Name 2',
    'batchName': 'Batch 4',
    'standard': 'IX',
    'startTime': const TimeOfDay(hour: 17, minute: 0),
    'endTime': const TimeOfDay(hour: 19, minute: 0),
  },
];
