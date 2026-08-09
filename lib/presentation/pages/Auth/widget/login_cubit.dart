import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  String phoneNumber = '';

  void updatePhoneNumber(String phone) {
    phoneNumber = phone;
  }

  Future<void> sendOtp() async {
    if (phoneNumber.trim().isEmpty) {
      emit(LoginError(message: 'الرجاء إدخال رقم الهاتف'));
      return;
    }

    emit(LoginLoading());
    debugPrint('🔹 Login Send OTP started...');
    debugPrint('📞 Phone: $phoneNumber');

    try {
      final data = await repository.loginSendOtp(phone: phoneNumber);
      debugPrint('📨 Response data: $data');

      if (data['status'] == 'success') {
        emit(LoginOtpSent(
          message: data['message'] ?? 'تم إرسال رمز التحقق بنجاح',
        ));
      } else {
        emit(LoginError(
          message: data['message'] ?? 'تعذّر إرسال رمز التحقق',
        ));
      }
    } catch (e) {
      debugPrint('💥 Login Send OTP error: $e');
      emit(LoginError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}