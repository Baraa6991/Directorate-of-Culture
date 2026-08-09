import 'package:intl/intl.dart';

class ActivityCardModel {
  final String id;
  final String culturalCenterId;
  final String? centerName; // اسم المركز الثقافي الحقيقي
  final String? activityTypeId; // معرف نوع الفعالية (للفلترة)
  final String type; // عنوان نوع الفعالية كما يعرضه الباك اند (activity_type.title)
  final String? venueId;
  final String? venueName; // اسم القاعة الحقيقي
  final String title;
  final String? presenterName;
  final String? presenterAvatar;
  final String description;
  final num? ticketPrice;
  final int? capacity;
  final int availableSeats;
  final DateTime? startTime;
  final DateTime? endTime;
  final String imageUrl;
  final bool isFavorite;

  const ActivityCardModel({
    required this.id,
    required this.culturalCenterId,
    this.centerName,
    this.activityTypeId,
    required this.type,
    this.venueId,
    this.venueName,
    required this.title,
    this.presenterName,
    this.presenterAvatar,
    required this.description,
    this.ticketPrice,
    this.capacity,
    required this.availableSeats,
    this.startTime,
    this.endTime,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory ActivityCardModel.fromJson(Map<String, dynamic> json) {
    return ActivityCardModel(
      id: json['id']?.toString() ?? '',

      culturalCenterId:
          json['cultural_center_id']?.toString() ?? '',

      centerName:
          (json['cultural_center'] is Map)
              ? json['cultural_center']['name']?.toString()
              : null,

      // ملاحظة: الباك اند لا يرجع 'type' مباشرة، بل يرجع
      // 'activity_type_id' و كائن 'activity_type' متضمناً 'title'
      activityTypeId:
          json['activity_type_id']?.toString(),

      type:
          (json['activity_type'] is Map)
              ? (json['activity_type']['title']?.toString() ?? '')
              : '',

      venueId:
          json['venue_id']?.toString(),

      venueName:
          (json['venue'] is Map)
              ? json['venue']['name']?.toString()
              : null,

      title:
          json['title']?.toString() ?? '',

      presenterName:
          json['presenter_name']?.toString(),

      presenterAvatar:
          json['presenter_avatar']?.toString(),

      description:
          json['description']?.toString() ?? '',

      // String -> num conversion
      ticketPrice:
          num.tryParse(json['ticket_price']?.toString() ?? ''),

      // String -> int conversion
      capacity:
          int.tryParse(json['capacity']?.toString() ?? ''),

      availableSeats:
          int.tryParse(json['available_seats']?.toString() ?? '') ?? 0,

      startTime:
          DateTime.tryParse(json['start_time']?.toString() ?? ''),

      endTime:
          DateTime.tryParse(json['end_time']?.toString() ?? ''),

      imageUrl:
          json['image']?.toString() ?? '',
    );
  }

  ActivityCardModel copyWith({
    bool? isFavorite,
  }) {
    return ActivityCardModel(
      id: id,
      culturalCenterId: culturalCenterId,
      centerName: centerName,
      activityTypeId: activityTypeId,
      type: type,
      venueId: venueId,
      venueName: venueName,
      title: title,
      presenterName: presenterName,
      presenterAvatar: presenterAvatar,
      description: description,
      ticketPrice: ticketPrice,
      capacity: capacity,
      availableSeats: availableSeats,
      startTime: startTime,
      endTime: endTime,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }


  // ─── Helpers للعرض في الكارد ───

  String get dateLabel =>
      startTime != null
          ? DateFormat('MMM dd').format(startTime!)
          : '';

  String get timeLabel =>
      startTime != null
          ? DateFormat('hh:mm a').format(startTime!)
          : '';

  String get locationLabel {
    // نفضّل الاسم الحقيقي دائماً؛ ولا نلجأ لعرض الـ id إلا إذا لم يصل الاسم
    // من الباك اند (مثلاً بسبب عدم تحميل العلاقة في هذا الـ endpoint تحديداً)
    if (venueId != null) {
      return venueName ?? 'قاعة رقم $venueId';
    }

    return centerName ?? 'مركز رقم $culturalCenterId';
  }

  String get seatsLabel =>
      capacity == null
          ? 'مقاعد غير محدودة'
          : '$availableSeats مقعداً متاحاً';


  String get typeLabel =>
      type.isEmpty
          ? ''
          : type[0].toUpperCase() + type.substring(1);
}