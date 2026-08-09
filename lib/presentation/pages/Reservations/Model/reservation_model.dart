import 'package:intl/intl.dart';

/// حالات أرشيف الحجوزات الأربع التي تظهر بالفلاتر (تُشتق من status الباك اند)
enum ReservationArchiveStatus {
  completed,   // مكتملة: تم الحضور فعلياً (COMPLETED)
  incomplete,  // غير مكتملة: محجوزة (مجانية أو مدفوعة سابقاً) ولم يُحضَر بعد (CONFIRMED)
  unpaid,      // غير مدفوعة: محجوزة لفعالية مدفوعة ولم يُدفَع بعد (PENDING_PAYMENT)
  cancelled,   // ملغاة (CANCELLED)
}

class ReservationModel {
  final int id;
  final String ticketId;
  final String? qrPayload;
  final String status; // القيمة الخام من الباك اند (CONFIRMED/PENDING_PAYMENT/COMPLETED/CANCELLED/WAIT_LIST)
  final bool canCancel;
  final bool canShowQr;
  final int seatsCount;
  final DateTime? reservationDate;
  final DateTime? createdAt;

  // بيانات الفعالية المرتبطة (مُسطَّحة للعرض المباشر بالكارد)
  final int activityId;
  final String activityTitle;
  final String? activityImage;
  final String activityTypeLabel;
  final DateTime? activityStartTime;
  final String? locationLabel;
  final num? ticketPrice;

  const ReservationModel({
    required this.id,
    required this.ticketId,
    this.qrPayload,
    required this.status,
    required this.canCancel,
    required this.canShowQr,
    required this.seatsCount,
    this.reservationDate,
    this.createdAt,
    required this.activityId,
    required this.activityTitle,
    this.activityImage,
    required this.activityTypeLabel,
    this.activityStartTime,
    this.locationLabel,
    this.ticketPrice,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final activity = json['activity'] is Map
        ? json['activity'] as Map<String, dynamic>
        : <String, dynamic>{};

    final center = activity['cultural_center'] is Map
        ? activity['cultural_center'] as Map<String, dynamic>
        : null;
    final venue = json['venue'] is Map
        ? json['venue'] as Map<String, dynamic>
        : (activity['venue'] is Map ? activity['venue'] as Map<String, dynamic> : null);

    return ReservationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      ticketId: json['ticket_id']?.toString() ?? '',
      qrPayload: json['qr_payload']?.toString(),
      status: json['status']?.toString() ?? '',
      canCancel: json['can_cancel'] == true,
      canShowQr: json['can_show_qr'] == true,
      seatsCount: int.tryParse(json['seats_count']?.toString() ?? '') ?? 1,
      reservationDate: json['reservation_date'] != null
          ? DateTime.tryParse(json['reservation_date'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      activityId: int.tryParse(activity['id']?.toString() ?? '') ?? 0,
      activityTitle: activity['title']?.toString() ?? '',
      activityImage: activity['image']?.toString(),
      activityTypeLabel: (activity['activity_type'] is Map)
          ? (activity['activity_type']['title']?.toString() ?? '')
          : '',
      activityStartTime: activity['start_time'] != null
          ? DateTime.tryParse(activity['start_time'].toString())
          : null,
      locationLabel: venue?['name']?.toString() ?? center?['name']?.toString(),
      ticketPrice: activity['ticket_price'] != null
          ? num.tryParse(activity['ticket_price'].toString())
          : null,
    );
  }

  ReservationArchiveStatus get archiveStatus {
    switch (status) {
      case 'COMPLETED':
        return ReservationArchiveStatus.completed;
      case 'PENDING_PAYMENT':
        return ReservationArchiveStatus.unpaid;
      case 'CANCELLED':
        return ReservationArchiveStatus.cancelled;
      case 'CONFIRMED':
      default:
        return ReservationArchiveStatus.incomplete;
    }
  }

  String get dateLabel => activityStartTime != null
      ? DateFormat('d MMM yyyy', 'ar').format(activityStartTime!)
      : '';

  String get timeLabel =>
      activityStartTime != null ? DateFormat('hh:mm a', 'ar').format(activityStartTime!) : '';

  String get priceLabel {
    if (ticketPrice == null || ticketPrice == 0) return 'دخول مجاني';
    return '$ticketPrice ريال';
  }
}
