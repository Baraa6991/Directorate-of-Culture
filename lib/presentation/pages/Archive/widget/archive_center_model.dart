import 'archive_event_model.dart' show ArchiveReservationStatus;

class ArchiveCenterModel {
  final String id;
  final String title;
  final String reservationCode;
  final String date;
  final ArchiveReservationStatus status;
  final String? rejectionReason;
  final String actionLabel;
  final bool showShareIcon;

  const ArchiveCenterModel({
    required this.id,
    required this.title,
    required this.reservationCode,
    required this.date,
    required this.status,
    this.rejectionReason,
    required this.actionLabel,
    this.showShareIcon = false,
  });
}
