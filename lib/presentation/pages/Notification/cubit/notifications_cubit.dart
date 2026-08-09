import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Notification/cubit/notifications_state.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/foundation.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final MiscRepository repository;
  static const int perPage = 15;

  NotificationsCubit({required this.repository}) : super(const NotificationsState());

  Future<void> loadFirstPage() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final items = await repository.getNotifications(page: 1);
      emit(state.copyWith(
        items: items,
        currentPage: 1,
        isLoading: false,
        hasMore: items.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Notifications load error: $e');
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
      final items = await repository.getNotifications(page: nextPage);
      emit(state.copyWith(
        items: [...state.items, ...items],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: items.length == perPage,
      ));
    } catch (e) {
      debugPrint('💥 Notifications load more error: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  /// تعليم إشعار واحد كمقروء فور الضغط عليه (تحديث فوري بالواجهة + الباك اند)
  Future<void> markAsRead(String id) async {
    final updated = state.items
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    emit(state.copyWith(items: updated));
    try {
      await repository.markNotificationAsRead(id);
    } catch (e) {
      debugPrint('💥 Mark as read error: $e');
    }
  }

  /// تُستدعى عند مغادرة الشاشة — تُعلِّم كل الإشعارات كمقروءة، فيختفي
  /// الرقم الأحمر على جرس الإشعارات بالرئيسية تلقائياً بعد العودة إليها.
  Future<void> markAllAsRead() async {
    try {
      await repository.markAllNotificationsAsRead();
    } catch (e) {
      debugPrint('💥 Mark all as read error: $e');
    }
  }

  Future<void> delete(String id) async {
    final updated = state.items.where((n) => n.id != id).toList();
    emit(state.copyWith(items: updated));
    try {
      await repository.deleteNotification(id);
    } catch (e) {
      debugPrint('💥 Delete notification error: $e');
    }
  }
}