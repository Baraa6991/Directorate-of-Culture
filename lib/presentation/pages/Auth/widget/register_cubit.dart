import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiRepository repository;

  RegisterCubit({required this.repository}) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String phone,
    required DateTime? birthdate,
    required String? gender,
  }) async {
    // فاليديشن بسيط قبل الإرسال
    if (name.trim().isEmpty) {
      emit(RegisterError(message: 'الرجاء إدخال الاسم الكامل'));
      return;
    }
    if (phone.trim().isEmpty) {
      emit(RegisterError(message: 'الرجاء إدخال رقم الهاتف'));
      return;
    }
    if (birthdate == null) {
      emit(RegisterError(message: 'الرجاء اختيار تاريخ الميلاد'));
      return;
    }
    if (gender == null) {
      emit(RegisterError(message: 'الرجاء اختيار الجنس'));
      return;
    }

    emit(RegisterLoading());
    debugPrint('🔹 Register started...');
    debugPrint('👤 Name: $name');
    debugPrint('📞 Phone: $phone');
    debugPrint('🎂 Birthdate: $birthdate');
    debugPrint('⚧ Gender: $gender');

    try {
      final data = await repository.register(
        name: name,
        phone: phone,
        dateOfBirth: DateFormat('yyyy-MM-dd').format(birthdate),
        gender: gender,
      );

      debugPrint('📨 Response data: $data');

      if (data['status'] == 'success') {
        emit(RegisterSuccess(
          message: data['message'] ?? 'تم إرسال رمز التحقق بنجاح',
        ));
      } else {
        emit(RegisterError(
          message: data['message'] ?? 'حدث خطأ أثناء التسجيل',
        ));
      }
    } catch (e) {
      debugPrint('💥 Register error: $e');
      emit(RegisterError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}