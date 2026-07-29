enum ArchiveReservationStatus {
  confirmedPaid,
  underReview,
  rejected,
  awaitingPayment,
  completed,
}

class ArchiveEventModel {
  final String id;
  final String title;
  final String? description;
  final String categoryBadge;
  final String? imageAsset;
  final String? date;
  final String? time;
  final String? reservationCode;
  final String? location;
  final ArchiveReservationStatus status;
  final String? rejectionReason;
  final String actionLabel;

  const ArchiveEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.categoryBadge,
    this.imageAsset,
    this.date,
    this.time,
    this.reservationCode,
    this.location,
    required this.status,
    this.rejectionReason,
    required this.actionLabel,
  });
}
