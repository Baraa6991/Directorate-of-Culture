class HallBookingFormState {
  final String requestingParty;
  final String applicantName;
  final String nationalIdNumber;
  final String reservationReason;
  final String eventDescription;
  final bool isPublic;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;

  const HallBookingFormState({
    this.requestingParty = '',
    this.applicantName = '',
    this.nationalIdNumber = '',
    this.reservationReason = '',
    this.eventDescription = '',
    this.isPublic = false,
    this.startDateTime,
    this.endDateTime,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  HallBookingFormState copyWith({
    String? requestingParty,
    String? applicantName,
    String? nationalIdNumber,
    String? reservationReason,
    String? eventDescription,
    bool? isPublic,
    DateTime? startDateTime,
    bool clearStartDateTime = false,
    DateTime? endDateTime,
    bool clearEndDateTime = false,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) {
    return HallBookingFormState(
      requestingParty: requestingParty ?? this.requestingParty,
      applicantName: applicantName ?? this.applicantName,
      nationalIdNumber: nationalIdNumber ?? this.nationalIdNumber,
      reservationReason: reservationReason ?? this.reservationReason,
      eventDescription: eventDescription ?? this.eventDescription,
      isPublic: isPublic ?? this.isPublic,
      startDateTime: clearStartDateTime
          ? null
          : (startDateTime ?? this.startDateTime),
      endDateTime: clearEndDateTime ? null : (endDateTime ?? this.endDateTime),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
