import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Cubit/reservations_archive_state.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Model/reservation_model.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/foundation.dart';

class ReservationsArchiveCubit extends Cubit<ReservationsArchiveState> {
  final MiscRepository repository;
  static const int perPage = 10;

  ReservationsArchiveCubit({required this.repository})
      : super(const ReservationsArchiveState());

  /// يحوّل حالة التبويب (بالفلاتر) إلى القيمة الخام المطلوبة بالباك اند
  /// للفلترة server-side. تبويب "غير مكتملة" يشمل CONFIRMED فقط (وليس
  /// WAIT_LIST، فتلك ليست تذكرة فعلية بعد).
  String get _statusParam {
    switch (state.activeTab) {
      case ReservationArchiveStatus.completed:
        return 'COMPLETED';
      case ReservationArchiveStatus.incomplete:
        return 'CONFIRMED';
      case ReservationArchiveStatus.unpaid:
        return 'PENDING_PAYMENT';
      case ReservationArchiveStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Future<void> changeTab(ReservationArchiveStatus tab) async {
    if (tab == state.activeTab) return;
    emit(ReservationsArchiveState(activeTab: tab));
    await loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final items = await repository.getReservations(
        page: 1,
        perPage: perPage,
        status: _statusParam,
      );
      emit(state.copyWith(
        items: items,
        currentPage: 1,
        isLoading: false,
        hasMore: items.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Reservations archive load error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    try {
      final items = await repository.getReservations(
        page: nextPage,
        perPage: perPage,
        status: _statusParam,
      );
      emit(state.copyWith(
        items: [...state.items, ...items],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: items.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Reservations archive load more error: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  /// إلغاء حجز، مع إزالته فوراً من القائمة المعروضة (تجربة استخدام أسرع
  /// من إعادة تحميل الصفحة بالكامل من السيرفر).
  Future<void> cancel(ReservationModel reservation) async {
    try {
      await repository.cancelReservation(reservation.id.toString());
      final updated = state.items.where((r) => r.id != reservation.id).toList();
      emit(state.copyWith(items: updated));
    } catch (e) {
      debugPrint('💥 Cancel reservation error: $e');
      rethrow; // لتعرض الشاشة رسالة الخطأ العربية عبر SnackBar
    }
  }
}
