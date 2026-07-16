import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';

class ApiRepository {
  final ApiClient _client;

  ApiRepository({ApiClient? client}) : _client = client ?? ApiClient();

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
}
