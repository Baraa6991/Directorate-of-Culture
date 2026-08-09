import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';

class BookEventState {
  final ActivityCardModel activity;
  final int attendees;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, dynamic>? reservationData;

  const BookEventState({
    required this.activity,
    this.attendees = 1,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
    this.reservationData,
  });

  /// الحد الأقصى لعدد الحضور المسموح به في الحجز الواحد (10 كحد أقصى، أو أقل
  /// حسب السعة الكلية للفعالية إن وُجدت).
  int get maxGuests {
    final capacity = activity.capacity;
    if (capacity == null || capacity > 10) return 10;
    return capacity < 1 ? 1 : capacity;
  }

  /// عدد المقاعد المتاحة فعلياً القادم من الباك اند
  int get seatsAvailable => activity.availableSeats;

  BookEventState copyWith({
    ActivityCardModel? activity,
    int? attendees,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
    Map<String, dynamic>? reservationData,
  }) {
    return BookEventState(
      activity: activity ?? this.activity,
      attendees: attendees ?? this.attendees,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
      reservationData: reservationData ?? this.reservationData,
    );
  }
}