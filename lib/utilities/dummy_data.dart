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

final List<String> dummyBatchNames = [
  'Batch 1',
  'Batch 2',
  'Batch 3',
  'Batch 4',
];

final List<String> dummyEducationBoards = [
  'State Board',
  'CBSE',
  'ICSE',
  'IG',
];

final List<String> dummyStandards = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X',
  'XI',
  'XII',
];

final List<String> dummyStudentNames = [
  'Student Name 1',
  'Student Name 2',
  'Student Name 3',
  'Student Name 4',
  'Student Name 5',
  'Student Name 6',
  'Student Name 7',
  'Student Name 8',
  'Student Name 9',
  'Student Name 10',
  'Student Name 11',
  'Student Name 12',
  'Student Name 13',
  'Student Name 14',
  'Student Name 15',
];

final Map<String, dynamic> dummyStudentDetails = {
  'name': 'Student Name',
  'phoneNumber': '+91 1234567890',
  'emailAddress': 'studentname@email.com',
  'gender': 'Male',
  'schoolName': 'School Name public school',
  'academicYear': '2000 - 2002',
  'educationBoard': 'CBSE',
  'standard': 'XI',
  'addressLine1': 'This is the address line 1 of the student',
  'addressLine2': 'This is the address line 2 of the student',
  'pincode': '123456',
  'city': 'City',
  'state': 'State',
  'country': 'Country',
  'parentsName': "Parent's Name",
  'parentalRole': 'Mother',
  'parentsPhoneNumber': '+91 1234512345',
  'parentsEmailAddress': 'parentname@email.com',
};
