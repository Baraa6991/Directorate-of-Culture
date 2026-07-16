
class ApiConstants {
  static final baseUrl ='http://192.168.43.41:8000/api';
  static String register() => '$baseUrl/register/send-otp';
  static String registerVerifyOTP() => '$baseUrl/register/verify-otp';
  static String registerOTPResend() => '$baseUrl/register/resend-otp';
  static String loginSendOtp() => '$baseUrl/login/send-otp';
  static String loginVerifyOtp() => '$baseUrl/login/verify-otp';
}
