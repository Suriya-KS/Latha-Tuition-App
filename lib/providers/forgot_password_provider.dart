import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ForgotPasswordContent {
  sendVerificationLink,
  acknowledgement,
}

enum ForgotPassword {
  inputText,
  activeContent,
}

final initialState = {
  ForgotPassword.inputText: '',
  ForgotPassword.activeContent: ForgotPasswordContent.sendVerificationLink,
};

class ForgotPasswordNotifier
    extends StateNotifier<Map<ForgotPassword, dynamic>> {
  ForgotPasswordNotifier() : super(initialState);

  void switchToAcknowledgementContent(String enteredInputText) {
    state = {
      ...state,
      ForgotPassword.inputText: enteredInputText,
      ForgotPassword.activeContent: ForgotPasswordContent.acknowledgement,
    };
  }

  void resetState() => state = initialState;
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, Map<ForgotPassword, dynamic>>(
  (ref) => ForgotPasswordNotifier(),
);
