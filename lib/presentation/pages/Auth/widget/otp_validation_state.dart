part of 'otp_validation_cubit.dart';

abstract class OtpValidationState {}

class OtpValidationInitial extends OtpValidationState {}

class OtpValidationLoading extends OtpValidationState {}

class OtpValidationSuccess extends OtpValidationState {
  final String message;
  final String token;
  OtpValidationSuccess({required this.message, required this.token});
}

class OtpValidationError extends OtpValidationState {
  final String message;
  OtpValidationError({required this.message});
}

// ====================== RESEND STATES ======================
class OtpResendLoading extends OtpValidationState {}

class OtpResendSuccess extends OtpValidationState {
  final String message;
  OtpResendSuccess({required this.message});
}

class OtpResendError extends OtpValidationState {
  final String message;
  OtpResendError({required this.message});
}