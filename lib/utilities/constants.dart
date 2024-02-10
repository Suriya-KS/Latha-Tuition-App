import 'package:flutter/material.dart';

const primaryColor = Color(0xFF08D9D6);
const primaryBackgroundColor = Color(0xFFEAEAEA);
const secondaryColor = Color(0xFFFF2E63);
const secondaryBackgroundColor = Color(0xFF252A34);

const teachingImage = "assets/images/teaching.svg";
const studyingImage = "assets/images/studying.svg";
const reportImage = "assets/images/report.svg";
const welcomeImage = "assets/images/welcome.svg";
const handWaveImage = "assets/images/hand_wave.svg";
const handshakeImage = "assets/images/handshake.svg";
const celebrateImage = "assets/images/celebrate.svg";
const newEntryImage = "assets/images/new_entry.svg";
const forgotPasswordImage = "assets/images/forgot_password.svg";
const confirmImage = "assets/images/confirm.svg";
const placeholderImage = "assets/images/placeholder.svg";

const alphabets = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
const specialCharacters = ' !"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';

const passwordVerificationCodeResendTime = Duration(seconds: 60);

const screenPadding = 30.0;

enum Screen {
  onboarding,
  login,
  signUp,
  studentRegistration,
}

enum PasswordRecoveryMethod {
  email,
  sms,
}

enum ForgotPasswordForm {
  sendVerificationCode,
  verifyCode,
}
