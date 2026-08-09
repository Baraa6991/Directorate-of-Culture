import 'package:directorateofculture/presentation/pages/Reservations/Model/reservation_model.dart';

class ReservationsArchiveState {
  final List<ReservationModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final bool hasMore;
  final ReservationArchiveStatus activeTab;
  final String? errorMessage;

  const ReservationsArchiveState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.activeTab = ReservationArchiveStatus.incomplete,
    this.errorMessage,
  });

  ReservationsArchiveState copyWith({
    List<ReservationModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasMore,
    ReservationArchiveStatus? activeTab,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReservationsArchiveState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      activeTab: activeTab ?? this.activeTab,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
