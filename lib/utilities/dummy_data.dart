import 'package:flutter/material.dart';

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

final List<Map<String, dynamic>> dummyBatchAttendance = [
  {
    'name': dummyStudentNames[0],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[1],
    'attendanceStatus': 'absent',
  },
  {
    'name': dummyStudentNames[2],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[3],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[4],
    'attendanceStatus': 'absent',
  },
  {
    'name': dummyStudentNames[5],
    'attendanceStatus': 'absent',
  },
  {
    'name': dummyStudentNames[6],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[7],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[8],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[9],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[10],
    'attendanceStatus': 'absent',
  },
  {
    'name': dummyStudentNames[11],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[12],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[13],
    'attendanceStatus': 'present',
  },
  {
    'name': dummyStudentNames[14],
    'attendanceStatus': 'present',
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

final List<Map<String, dynamic>> dummyBatchTestMarks = [
  {
    'name': dummyStudentNames[0],
    'marks': 52,
  },
  {
    'name': dummyStudentNames[1],
    'marks': 36,
  },
  {
    'name': dummyStudentNames[2],
    'marks': 87,
  },
  {
    'name': dummyStudentNames[3],
    'marks': 98,
  },
  {
    'name': dummyStudentNames[4],
    'marks': 67,
  },
  {
    'name': dummyStudentNames[5],
    'marks': 43,
  },
  {
    'name': dummyStudentNames[6],
    'marks': 21,
  },
  {
    'name': dummyStudentNames[7],
    'marks': 90,
  },
  {
    'name': dummyStudentNames[8],
    'marks': 75,
  },
  {
    'name': dummyStudentNames[9],
    'marks': 11,
  },
  {
    'name': dummyStudentNames[10],
    'marks': 64,
  },
  {
    'name': dummyStudentNames[11],
    'marks': 55,
  },
  {
    'name': dummyStudentNames[12],
    'marks': 88,
  },
  {
    'name': dummyStudentNames[13],
    'marks': 70,
  },
  {
    'name': dummyStudentNames[14],
    'marks': 69,
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

final List<Map<String, dynamic>> dummyStudentAttendance = [
  {
    'date': DateTime.now(),
    'time': '08:00 am - 10:00 am',
    'attendanceStatus': 'absent',
  },
  {
    'date': DateTime(2002, 3, 5),
    'time': '11:00 am - 12:00 pm',
    'attendanceStatus': 'present',
  },
  {
    'date': DateTime(2000, 8, 18),
    'time': '03:30 am - 05:00 pm',
    'attendanceStatus': 'present',
  },
];

final List<Map<String, dynamic>> dummyStudentTestMarks = [
  {
    'name': 'Test name 1',
    'date': DateTime.now(),
    'time': '08:00 am - 10:00 am',
    'marks': 82,
    'totalMarks': 100
  },
  {
    'name': 'Test name 2',
    'date': DateTime(2002, 3, 5),
    'time': '11:00 am - 12:00 pm',
    'marks': 69,
    'totalMarks': 200
  },
  {
    'name': 'Test name 3',
    'date': DateTime(2000, 8, 18),
    'time': '03:30 am - 05:00 pm',
    'marks': 96,
    'totalMarks': 100
  },
];

final List<Map<String, dynamic>> dummyStudentPaymentHistory = [
  {
    'date': DateTime(2002, 3, 5),
    'amount': 2000.2,
    'status': 'approved',
  },
  {
    'date': DateTime(2000, 8, 18),
    'amount': 1500,
    'status': 'approved',
  },
  {
    'date': DateTime.now(),
    'amount': 2200.5,
    'status': 'rejected',
  },
];

final List<Map<String, dynamic>> dummyStudentFeedbacks = [
  {
    'date': DateTime.now(),
    'message':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla in mauris eget sapien feugiat condimentum sit amet ac arcu. Nulla porta arcu ac efficitur consectetur. In sed felis orci. Integer commodo cursus augue, auctor dignissim nibh volutpat a. Fusce odio nibh, tempus vel facilisis at, facilisis non libero. Curabitur sed neque mattis, accumsan sapien ultricies, vehicula arcu. Integer ullamcorper at ex sit amet tristique. Proin eget fringilla quam. Nam sit amet vulputate erat. Nam varius scelerisque felis, ut vestibulum leo sagittis ac. Aliquam tristique feugiat ante quis dictum. Suspendisse fermentum euismod venenatis. Mauris eget consectetur tellus, vitae eleifend lacus.'
  },
  {
    'date': DateTime(2002, 3, 5),
    'message':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce imperdiet risus justo, eget egestas nisl ultricies non. Suspendisse ac elit leo. Cras posuere porta purus, nec egestas dolor posuere nec. Nam dolor urna, ultrices ac vestibulum ac, pretium cursus urna. Cras viverra rutrum est, egestas maximus nulla. Proin vitae dolor sagittis, dignissim urna a, vestibulum est. Nam id nunc commodo, aliquam dolor et, bibendum ipsum. Suspendisse erat diam, auctor ac eleifend nec, pharetra in massa.',
  },
  {
    'date': DateTime(2000, 8, 18),
    'message':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc a enim et nulla auctor molestie non sit amet erat. Nunc quam diam, sodales ac odio a, blandit dictum augue. Aenean at justo at nibh pellentesque rutrum nec sed eros. Maecenas efficitur quis magna nec porta. Donec dapibus non tellus non fringilla. Suspendisse nibh odio, tempor quis est a, consectetur interdum velit. Etiam enim lacus, dapibus a eros ac, vehicula mollis eros. Fusce in lacus ac ipsum vulputate ullamcorper. Sed sodales magna in vulputate pellentesque.',
  },
];

final List<Map<String, dynamic>> dummyStudentApprovals = [
  dummyStudentDetails,
  dummyStudentDetails,
  dummyStudentDetails,
];

final List<Map<String, dynamic>> dummyBatchPaymentHistory = [
  {
    'name': dummyStudentNames[0],
    'date': DateTime(2002, 3, 5),
    'amount': 2000.2,
    'status': 'approved',
  },
  {
    'name': dummyStudentNames[1],
    'date': DateTime(2000, 8, 18),
    'amount': 1500,
    'status': 'approved',
  },
  {
    'name': dummyStudentNames[2],
    'date': DateTime.now(),
    'amount': 2200.5,
    'status': 'rejected',
  },
];

final List<Map<String, dynamic>> dummyBatchPaymentApproval = [
  {
    'name': dummyStudentNames[0],
    'batchName': 'Batch 2',
    'date': DateTime(2002, 3, 5),
    'amount': 2000.2,
  },
  {
    'name': dummyStudentNames[1],
    'batchName': 'Batch 2',
    'date': DateTime(2000, 8, 18),
    'amount': 1500,
  },
  {
    'name': dummyStudentNames[2],
    'batchName': 'Batch 3',
    'date': DateTime.now(),
    'amount': 2200.5,
  },
];

final List<Map<String, dynamic>> dummyUpcomingClasses = [
  {
    'batchName': 'Batch 1',
    'standard': 'XII',
    'date': DateTime.now(),
    'startTime': const TimeOfDay(hour: 11, minute: 0),
    'endTime': const TimeOfDay(hour: 12, minute: 0),
  },
  {
    'batchName': 'Batch 2',
    'standard': 'VIII',
    'date': DateTime(2002, 3, 5),
    'startTime': const TimeOfDay(hour: 14, minute: 0),
    'endTime': const TimeOfDay(hour: 17, minute: 0),
  },
];

final List<Map<String, dynamic>> dummyScheduledTests = [
  {
    'testName': 'Test Name 1',
    'batchName': 'Batch 2',
    'standard': 'XII',
    'date': DateTime.now(),
    'startTime': const TimeOfDay(hour: 11, minute: 0),
    'endTime': const TimeOfDay(hour: 12, minute: 0),
  },
  {
    'testName': 'Test Name 2',
    'batchName': 'Batch 3',
    'standard': 'VIII',
    'date': DateTime(2002, 3, 5),
    'startTime': const TimeOfDay(hour: 14, minute: 0),
    'endTime': const TimeOfDay(hour: 17, minute: 0),
  },
];
