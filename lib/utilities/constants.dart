import 'package:flutter/material.dart';

const seedColor = Color(0xFF08D9D6);
const darkSeedColor = Color(0xFF006A68);

const onboardingImage1 = "assets/images/teaching.svg";
const onboardingImage1Dark = "assets/images/teaching_dark.svg";
const onboardingImage2 = "assets/images/studying.svg";
const onboardingImage2Dark = "assets/images/studying_dark.svg";
const onboardingImage3 = "assets/images/welcome.svg";
const onboardingImage3Dark = "assets/images/welcome_dark.svg";
const classRoomImage = "assets/images/class_room.svg";
const classRoomImageDark = "assets/images/class_room_dark.svg";
const loginImage = "assets/images/hand_wave.svg";
const loginImageDark = "assets/images/hand_wave_dark.svg";
const tutorSignUpImage = "assets/images/handshake.svg";
const tutorSignUpImageDark = "assets/images/handshake_dark.svg";
const studentSignUpImage = "assets/images/celebrate.svg";
const studentSignUpImageDark = "assets/images/celebrate_dark.svg";
const studentRegistrationImage = "assets/images/new_entry.svg";
const studentRegistrationImageDark = "assets/images/new_entry_dark.svg";
const forgotPasswordImage = "assets/images/forgot_password.svg";
const forgotPasswordImageDark = "assets/images/forgot_password_dark.svg";
const resetPasswordImage = "assets/images/confirm.svg";
const resetPasswordImageDark = "assets/images/confirm_dark.svg";
const batchPaymentImage = "assets/images/group_payment.svg";
const batchPaymentImageDark = "assets/images/group_payment_dark.svg";
const searchStudentImage = "assets/images/search.svg";
const searchStudentImageDark = "assets/images/search_dark.svg";
const newAdmissionsImage = "assets/images/pending_approval.svg";
const newAdmissionsImageDark = "assets/images/pending_approval_dark.svg";
const paymentConfirmImage = "assets/images/payment_confirm.svg";
const paymentConfirmImageDark = "assets/images/payment_confirm_dark.svg";
const awaitingApprovalImage = "assets/images/waiting.svg";
const awaitingApprovalImageDark = "assets/images/waiting_dark.svg";
const noNetworkImage = "assets/images/no_network.svg";
const noNetworkImageDark = "assets/images/no_network_dark.svg";
const warningImage = "assets/images/warning.svg";
const warningImageDark = "assets/images/warning_dark.svg";
const notFoundImage = "assets/images/not_found.svg";
const notFoundImageDark = "assets/images/not_found_dark.svg";
const placeholderImage = "assets/images/placeholder.svg";
const placeholderImageDark = "assets/images/placeholder_dark.svg";

const splashLoadingVideo = "assets/videos/books_loading.mp4";
const splashLoadingVideoDark = "assets/videos/books_loading_dark.mp4";

const alphabets = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
const specialCharacters = ' !"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
const defaultErrorMessage = 'Something went wrong, please try again later';

const splashLoadingVideoDuration = Duration(seconds: 5);
const passwordVerificationCodeResendTime = Duration(seconds: 60);

const screenPadding = 20.0;

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
