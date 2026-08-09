import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';
import 'center_details_state.dart';

class CenterDetailsCubit extends Cubit<CenterDetailsState> {
  final HomeRepository repository;

  CenterDetailsCubit({required this.repository})
      : super(const CenterDetailsState());

  Future<void> loadCenter(String id) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final center = await repository.getCenterDetails(id);
      emit(state.copyWith(center: center, isLoading: false));
    } catch (e) {
      debugPrint('💥 CenterDetails error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}