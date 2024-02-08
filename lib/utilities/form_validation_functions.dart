import 'package:latha_tuition_app/utilities/constants.dart';

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

String? validateEmail(String? value) {
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

  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  if (int.tryParse(value) == null) {
    return 'Phone number should only contain numeric digits';
  }

  if (value.length != 10) {
    return 'Phone number must be 10 digits long';
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

String? validateRequiredInput(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $fieldName';
  }
  return null;
}
