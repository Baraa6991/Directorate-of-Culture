import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Home/model/activity_model.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';

part 'coming_activities_state.dart';

class ComingActivitiesCubit extends Cubit<ComingActivitiesState> {
  final HomeRepository repository;
  static const int perPage = 5;

  ComingActivitiesCubit({required this.repository})
      : super(ComingActivitiesState());

  Future<void> loadFirstPage() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    debugPrint('🔹 Loading coming activities - page 1...');

    try {
      final data = await repository.getComingActivities(
        page: 1,
        perPage: perPage,
      );
      final list = (data['data'] as List<dynamic>? ?? [])
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(
        activities: list,
        currentPage: 1,
        isLoading: false,
        hasMore: list.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Coming activities error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  // يُستدعى تلقائياً عند الوصول لنهاية القائمة الأفقية
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    debugPrint('🔹 Loading coming activities - page $nextPage...');

    try {
      final data = await repository.getComingActivities(
        page: nextPage,
        perPage: perPage,
      );
      final list = (data['data'] as List<dynamic>? ?? [])
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(
        activities: [...state.activities, ...list],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: list.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Coming activities load more error: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}