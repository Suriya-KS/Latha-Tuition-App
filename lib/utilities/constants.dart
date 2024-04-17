import 'package:flutter/material.dart';

const seedColor = Color(0xFF08D9D6);

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
const notFoundImage = "assets/images/not_found.svg";
const searchImage = "assets/images/search.svg";
const pendingApprovalImage = "assets/images/pending_approval.svg";
const phoneConfirmImage = "assets/images/phone_confirm.svg";
const groupPaymentImage = "assets/images/group_payment.svg";
const errorImage = "assets/images/error.svg";
const waitingImage = "assets/images/waiting.svg";
const placeholderImage = "assets/images/placeholder.svg";

const alphabets = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
const specialCharacters = ' !"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
const defaultErrorMessage = 'Something went wrong, please try again later';

const passwordVerificationCodeResendTime = Duration(seconds: 60);

const screenPadding = 30.0;

enum Screen {
  onboarding,
  login,
  signUp,
  studentRegistration,
  tutorEventsView,
  tutorTrackRecordSheet,
  attendance,
  testMarks,
  studentAwaitingApproval,
  studentFetchAdmissionStatusSheet,
}

enum UserType {
  student,
  tutor,
}
