import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PasswordRecoveryMethod {
  email,
  sms,
}

enum ForgotPasswordForm {
  sendVerificationCode,
  verifyCode,
}

enum ForgotPassword {
  recoveryMethod,
  inputText,
  activeForm,
}

final initialState = {
  ForgotPassword.recoveryMethod: null,
  ForgotPassword.inputText: '',
  ForgotPassword.activeForm: ForgotPasswordForm.sendVerificationCode,
};

class ForgotPasswordNotifier
    extends StateNotifier<Map<ForgotPassword, dynamic>> {
  ForgotPasswordNotifier() : super(initialState);

  void setRecoveryMethod(PasswordRecoveryMethod recoveryMethod) {
    state = {
      ...state,
      ForgotPassword.recoveryMethod: recoveryMethod,
    };
  }

  void switchToVerifyCodeForm(String enteredInputText) {
    state = {
      ...state,
      ForgotPassword.inputText: enteredInputText,
      ForgotPassword.activeForm: ForgotPasswordForm.verifyCode,
    };
  }

  void resetState() => state = initialState;
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, Map<ForgotPassword, dynamic>>(
  (ref) => ForgotPasswordNotifier(),
);
