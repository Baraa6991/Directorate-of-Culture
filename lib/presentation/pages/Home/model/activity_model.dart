class ActivityModel {
  final int id;
  final int? culturalCenterId;
  final String? centerName;
  final String type;
  final String title;
  final String hostName;
  final String description;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? image;

  ActivityModel({
    required this.id,
    this.culturalCenterId,
    this.centerName,
    required this.type,
    required this.title,
    required this.hostName,
    required this.description,
    this.startTime,
    this.endTime,
    this.image,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      culturalCenterId: json['cultural_center_id'] != null
          ? int.tryParse(json['cultural_center_id'].toString())
          : null,

      // ✅ الباك اند يرجع كائن متداخل 'cultural_center': {id, name}
      // وليس نصاً مسطّحاً 'cultural_center_name'
      centerName: (json['cultural_center'] is Map)
          ? json['cultural_center']['name'] as String?
          : null,

      // ✅ الباك اند يرجع كائن متداخل 'activity_type': {id, title}
      // وليس نصاً مباشراً 'type'
      type: (json['activity_type'] is Map)
          ? (json['activity_type']['title'] as String? ?? '')
          : '',

      title: json['title'] as String? ?? '',

      // ✅ الحقل الفعلي بالباك اند اسمه 'presenter_name' وليس 'host_name'
      hostName: json['presenter_name'] as String? ?? '',

      description: json['description'] as String? ?? '',

      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'].toString())
          : null,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'].toString())
          : null,

      image: json['image'] as String?,
    );
  }
}