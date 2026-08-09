import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Auth/model/userProfile_model.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  final bool isSaving;
  ProfileLoaded(this.profile, {this.isSaving = false});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileLoading());

  Future<void> load() async {
    emit(ProfileLoading());
    try {
      final response = await repository.getProfile();
      final userJson = response['user'] as Map<String, dynamic>;
      emit(ProfileLoaded(UserProfileModel.fromJson(userJson)));
    } catch (e) {
      debugPrint('💥 Profile load error: $e');
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String dateOfBirth,
    required String gender,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) return false;

    emit(ProfileLoaded(current.profile, isSaving: true));
    try {
      final response = await repository.updateProfile(
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      final userJson = response['user'] as Map<String, dynamic>;
      emit(ProfileLoaded(UserProfileModel.fromJson(userJson)));
      return true;
    } catch (e) {
      debugPrint('💥 Profile update error: $e');
      emit(ProfileLoaded(current.profile, isSaving: false));
      rethrow;
    }
  }

  Future<bool> uploadAvatar(File imageFile) async {
    final current = state;
    if (current is! ProfileLoaded) return false;

    emit(ProfileLoaded(current.profile, isSaving: true));
    try {
      final response = await repository.uploadAvatar(imageFile);
      final userJson = response['user'] as Map<String, dynamic>;
      emit(ProfileLoaded(UserProfileModel.fromJson(userJson)));
      return true;
    } catch (e) {
      debugPrint('💥 Avatar upload error: $e');
      emit(ProfileLoaded(current.profile, isSaving: false));
      rethrow;
    }
  }
}