import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latha_tuition_app/utilities/constants.dart';

Future<bool> validateUnique(String? value, String type) async {
  try {
    final firestore = FirebaseFirestore.instance;

    final studentQuerySnapshot = await firestore
        .collection('students')
        .where(type, isEqualTo: value)
        .get();

    final studentAdmissionRequestQuerySnapshot = await firestore
        .collection('studentAdmissionRequests')
        .where(type, isEqualTo: value)
        .get();

    final tutorQuerySnapshot = await firestore
        .collection('tutors')
        .where(type, isEqualTo: value)
        .get();

    if (studentQuerySnapshot.size > 0 ||
        studentAdmissionRequestQuerySnapshot.size > 0 ||
        tutorQuerySnapshot.size > 0) {
      return false;
    }

    return true;
  } catch (error) {
    return false;
  }
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }

  for (int i = 0; i < value.length; i++) {
    String character = value[i];

    if (!(character == ' ' ||
        character == '.' ||
        alphabets.contains(character))) {
      return 'Please enter a valid name';
    }
  }

  if (value.length > 100) {
    return 'Name must not exceed 100 characters';
  }

  return null;
}

String? validateEmail(
  String? value, {
  String? secondaryField,
  String? secondaryValue,
}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }

  int indexOfAtSymbol = value.indexOf('@');
  int indexOfLastDot = value.lastIndexOf('.');
  int lastIndex = value.length - 1;

  if (!value.contains('@') ||
      indexOfAtSymbol == 0 ||
      indexOfAtSymbol == lastIndex) {
    return 'Please enter a valid email address';
  }

  if (value[indexOfAtSymbol + 1] == '.') {
    return 'Please enter a valid email address';
  }

  if (!value.substring(indexOfAtSymbol + 1).contains('.') ||
      indexOfLastDot == lastIndex) {
    return 'Please enter a valid email address';
  }

  if (indexOfLastDot - indexOfAtSymbol <= 1) {
    return 'Please enter a valid email address';
  }

  if (secondaryField == null) return null;

  if (value == secondaryValue) {
    return "Email address can't be same as $secondaryField";
  }

  return null;
}

String? validatePhoneNumber(
  String? value, {
  String? secondaryField,
  String? secondaryValue,
}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  if (int.tryParse(value) == null) {
    return 'Phone number should only contain numeric digits';
  }

  if (value.length != 10) {
    return 'Phone number must be 10 digits long';
  }

  if (secondaryField == null) return null;

  if (value == secondaryValue) {
    return "Phone number can't be same as $secondaryField";
  }

  return null;
}

String? validatePassword(String? value) {
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasDigit = false;
  bool hasSpecialCharacter = false;

  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }

  if (value.length > 36) {
    return 'Password must not exceed 36 characters';
  }

  for (int i = 0; i < value.length; i++) {
    final character = value[i];
    final uppercase = character.toUpperCase();
    final lowercase = character.toLowerCase();

    if (character == uppercase && character != lowercase) hasUppercase = true;
    if (character == lowercase && character != uppercase) hasLowercase = true;
    if (int.tryParse(character) != null) hasDigit = true;
    if (specialCharacters.contains(character)) hasSpecialCharacter = true;
  }

  if (!hasUppercase) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!hasLowercase) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!hasDigit) {
    return 'Password must contain at least one numeric digit';
  }

  if (!hasSpecialCharacter) {
    return 'Password must contain at least one special character';
  }

  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value != password) {
    return 'Passwords do not match';
  }

  return null;
}

String? validatePinCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a pin code';
  }

  if (value.length != 6 || int.tryParse(value) == null) {
    return 'Please enter a valid pin code';
  }

  return null;
}

String? validateDropdownValue(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select an option';
  }
  return null;
}

String? validateRequiredInput(
  String? value,
  String connector,
  String fieldName,
) {
  if (value == null || value.isEmpty) {
    return 'Please enter $connector $fieldName';
  }
  return null;
}

String? validateUpdateText(
  String? newValue,
  String? oldValue,
  String connector,
  String fieldName,
) {
  final textError = validateRequiredInput(newValue, connector, fieldName);

  if (textError != null) return textError;

  if (newValue == oldValue) {
    return 'Please provide a different $fieldName';
  }

  return null;
}

String? validateTotalMarks(String totalMarksString) {
  double? totalMarks = double.tryParse(totalMarksString);

  if (totalMarksString.isEmpty) {
    return 'Please enter the total marks';
  }

  if (totalMarks == null) {
    return 'Total marks must be a numeric value';
  }

  if (totalMarks <= 0) {
    return 'Total marks must be a positive number';
  }

  if (totalMarksString.contains('.') &&
      totalMarksString.split('.')[1].length > 2) {
    return 'Total marks can only have up to two decimal places';
  }

  return null;
}

String? validateMarks(String marksString, String totalMarksString) {
  double? totalMarks = double.tryParse(totalMarksString);
  double? marks = double.tryParse(marksString);

  if (marksString.isEmpty) {
    return 'Please enter the marks';
  }

  if (totalMarks == null) {
    return 'Total marks must be a numeric value';
  }

  if (marks == null) {
    return 'Marks must be numeric values';
  }

  if (marks < 0) {
    return 'Marks must be a positive number';
  }

  if (marks > totalMarks) {
    return "Mark can't be greater than total marks";
  }

  if (marksString.contains('.') && marksString.split('.')[1].length > 2) {
    return 'Marks can only have up to two decimal places';
  }

  return null;
}

String? validateFeesAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the fees amount';
  }

  double? amount = double.tryParse(value);

  if (amount == null) {
    return 'Please enter a valid amount';
  }

  if (amount <= 0) {
    return 'Fees amount must be greater than zero';
  }

  return null;
}

String? validateAuthentication(FirebaseAuthException error) {
  String errorMessage = '';

  switch (error.code) {
    case 'email-already-in-use':
      errorMessage = 'Email address is already registered';
      break;
    case 'invalid-credential':
      errorMessage = 'Email address or password is incorrect';
      break;
    default:
      errorMessage = 'Something went wrong, please try again later';
  }

  if (errorMessage != '') return errorMessage;

  return null;
}
