import 'dart:async';
import 'package:directorateofculture/Helper/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 3));

    // إن كان لدى المستخدم توكن مخزّن مسبقاً (سجّل دخول من قبل)
    // ننتقل للهوم مباشرة بدل شاشات تسجيل الدخول/الترحيب
    final token = CacheHelper.getToken();
    final hasToken = token != null && token.toString().isNotEmpty;

    if (hasToken) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToPersonalInfo());
    }
  }
}
