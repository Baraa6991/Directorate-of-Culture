import 'dart:io';
import 'package:dio/dio.dart';
import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';

/// كل ما يخص المصادقة: تسجيل حساب جديد، تسجيل الدخول، رموز OTP.
class AuthRepository {
  final ApiClient _client;

  AuthRepository({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String dateOfBirth, // بصيغة yyyy-MM-dd
    required String gender,
  }) {
    return _client.post(
      ApiConstants.register(),
      data: {
        'phone': phone.trim(),
        'name': name.trim(),
        'date_of_birth': dateOfBirth,
        'gender': gender.toLowerCase(),
      },
    );
  }

  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String phone,
    required String code,
  }) {
    return _client.postFormData(
      ApiConstants.registerVerifyOTP(),
      data: {'phone': phone.trim(), 'code': code.trim()},
    );
  }

  Future<Map<String, dynamic>> resendOtp({required String phone}) {
    return _client.post(
      ApiConstants.registerOTPResend(),
      data: {'phone': phone.trim()},
    );
  }

  Future<Map<String, dynamic>> loginSendOtp({required String phone}) {
    return _client.post(
      ApiConstants.loginSendOtp(),
      data: {'phone': phone.trim()},
    );
  }

  Future<Map<String, dynamic>> loginVerifyOtp({
    required String phone,
    required String code,
  }) {
    return _client.postFormData(
      ApiConstants.loginVerifyOtp(),
      data: {'phone': phone.trim(), 'code': code.trim()},
    );
  }

  Future<Map<String, dynamic>> resendLoginOtp({required String phone}) {
    return _client.post(
      ApiConstants.resendLoginOtp(),
      data: {
        'phone': phone.trim(),
      },
    );
  }

  Future<Map<String, dynamic>> getProfile() {
    return _client.get(ApiConstants.profile());
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? dateOfBirth, // yyyy-MM-dd
    String? gender, // male / female
  }) {
    return _client.put(
      ApiConstants.profile(),
      data: {
        if (name != null) 'name': name,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (gender != null) 'gender': gender.toLowerCase(),
      },
    );
  }

  /// رفع صورة الملف الشخصي من معرض الجهاز (يستقبل مسار الملف المحلي).
  Future<Map<String, dynamic>> uploadAvatar(File imageFile) {
    return _client.postFormData(
      ApiConstants.profileAvatar(),
      data: {
        'avatar': MultipartFile.fromFileSync(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
      },
    );
  }
}