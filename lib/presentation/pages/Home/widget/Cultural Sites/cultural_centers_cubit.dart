import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_center_card_model.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_centers_state.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';

class CulturalCentersCubit extends Cubit<CulturalCentersState> {
  final HomeRepository repository;
  List<CulturalCenterCardModel> _allCenters = const [];

  CulturalCentersCubit({required this.repository})
      : super(const CulturalCentersState());

  Future<void> loadCenters() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final centers = await repository.getCenters();
      _allCenters = centers;
      emit(state.copyWith(
        centers: centers,
        filteredCenters: centers,
        isLoading: false,
        query: '',
        clearErrorMessage: true,
      ));
    } catch (e) {
      debugPrint('💥 Centers load error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(state.copyWith(
          filteredCenters: _allCenters, query: query, clearErrorMessage: true));
      return;
    }
    final filtered = _allCenters.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
    }).toList();

    emit(state.copyWith(
        filteredCenters: filtered, query: query, clearErrorMessage: true));
  }
}