import 'package:bloc/bloc.dart';
import 'package:directorateofculture/Helper/cach_helper.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';


part 'otp_validation_state.dart';

enum OtpFlowType { register, login }

class OtpValidationCubit extends Cubit<OtpValidationState> {
  final ApiRepository repository;

  OtpValidationCubit({required this.repository})
      : super(OtpValidationInitial());

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required OtpFlowType flow,
  }) async {
    if (code.trim().length < 4) {
      emit(OtpValidationError(message: 'الرجاء إدخال رمز التحقق كاملاً'));
      return;
    }

    emit(OtpValidationLoading());
    debugPrint('🔹 Verify OTP started... flow: $flow');

    try {
      final data = flow == OtpFlowType.register
          ? await repository.verifyRegisterOtp(phone: phone, code: code)
          : await repository.loginVerifyOtp(phone: phone, code: code);

      debugPrint('📨 Response data: $data');

      if (data['status'] == 'success') {
        final token = data['token'] as String? ?? '';
        final user = data['user'] as Map<String, dynamic>?;

        await CacheHelper.saveData(key: 'token', value: token);
        if (user != null) {
          if (user['id'] != null) {
            await CacheHelper.saveData(key: 'user_id', value: user['id']);
          }
          if (user['name'] != null) {
            await CacheHelper.saveData(key: 'name', value: user['name']);
          }
          if (user['phone'] != null) {
            await CacheHelper.saveData(key: 'phone', value: user['phone']);
          }
        }

        emit(OtpValidationSuccess(
          message: data['message'] ?? 'تم التحقق بنجاح',
          token: token,
        ));
      } else {
        emit(OtpValidationError(
          message: data['message'] ?? 'رمز التحقق غير صحيح',
        ));
      }
    } catch (e) {
      debugPrint('💥 Verify OTP error: $e');
      emit(OtpValidationError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> resendOtp({
    required String phone,
    required OtpFlowType flow,
  }) async {
    emit(OtpResendLoading());
    debugPrint('🔹 Resend OTP started... flow: $flow');

    try {
      // ملاحظة: لو عندك endpoint مختلف لإعادة إرسال كود اللوغن أضفه هون بنفس المنطق
      final data = await repository.resendOtp(phone: phone);
      debugPrint('📨 Resend response: $data');

      if (data['status'] == 'success') {
        emit(OtpResendSuccess(
          message: data['message'] ?? 'تم إعادة إرسال الرمز بنجاح',
        ));
      } else {
        emit(OtpResendError(
          message: data['message'] ?? 'تعذّر إعادة إرسال الرمز',
        ));
      }
    } catch (e) {
      debugPrint('💥 Resend OTP error: $e');
      emit(OtpResendError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}