import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/events_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';

class ActivitiesCubit extends Cubit<ActivitiesState> {
  final HomeRepository repository;
  static const int perPage = 10;

  ActivitiesCubit({required this.repository}) : super(const ActivitiesState());

  /// يُستدعى مرة واحدة عند فتح الشاشة: يجلب قوائم الفلاتر الحقيقية
  /// (أنواع الفعاليات + المراكز) ثم أول صفحة من الفعاليات.
  Future<void> init() async {
    try {
      final results = await Future.wait([
        repository.getActivityTypeOptions(),
        repository.getCenterOptions(),
      ]);
      emit(state.copyWith(
        typeOptions: results[0],
        centerOptions: results[1],
      ));
    } catch (e) {
      debugPrint('💥 Filter options load error: $e');
      // فشل تحميل قوائم الفلاتر لا يجب أن يوقف عرض الفعاليات نفسها
    }
    await loadFirstPage();
  }

  /// يُستدعى عند فتح الشاشة لأول مرة، أو عند تغيير أي فلتر (بحث/نوع/مركز)
  /// — يبدأ من الصفحة 1 دائماً ويستبدل القائمة الحالية بالكامل.
  Future<void> loadFirstPage() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    debugPrint('🔹 Loading activities - page 1...');

    try {
      final list = await repository.getActivities(
        page: 1,
        perPage: perPage,
        search: state.query,
        centerId: state.selectedCenterId,
        activityTypeId: state.selectedTypeId,
      );

      emit(state.copyWith(
        activities: list,
        currentPage: 1,
        isLoading: false,
        hasMore: list.length == perPage,
        clearErrorMessage: true,
      ));
    } catch (e) {
      debugPrint('💥 Activities load error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// يُستدعى تلقائياً عند الوصول لنهاية القائمة أثناء التمرير (Infinite Scroll)
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    debugPrint('🔹 Loading activities - page $nextPage...');

    try {
      final list = await repository.getActivities(
        page: nextPage,
        perPage: perPage,
        search: state.query,
        centerId: state.selectedCenterId,
        activityTypeId: state.selectedTypeId,
      );

      emit(state.copyWith(
        activities: [...state.activities, ...list],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: list.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Activities load more error: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  // ─── الفلاتر: كل تغيير يعيد التحميل من الصفحة 1 من السيرفر ───

  void search(String query) {
    if (query == state.query) return;
    emit(state.copyWith(query: query));
    loadFirstPage();
  }

  void selectType(String? typeId) {
    emit(state.copyWith(selectedTypeId: typeId, clearType: typeId == null));
    loadFirstPage();
  }

  void selectCenter(String? centerId) {
    emit(state.copyWith(
      selectedCenterId: centerId,
      clearCenter: centerId == null,
    ));
    loadFirstPage();
  }

  // ─── مفضلة: تعديل محلي فوري بدون إعادة تحميل من السيرفر ───
  void toggleFavorite(String id) {
    final updated = state.activities
        .map((e) => e.id == id ? e.copyWith(isFavorite: !e.isFavorite) : e)
        .toList();
    emit(state.copyWith(activities: updated));
  }
}