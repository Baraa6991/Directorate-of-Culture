part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginOtpSent extends LoginState {
  final String message;
  LoginOtpSent({required this.message});
}

class LoginError extends LoginState {
  final String message;
  LoginError({required this.message});
}