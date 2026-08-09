class PlanStepModel {
  final String? time;
  final int activityId;
  final String activityTitle;
  final String? venueName;
  final String? centerName;
  final String? notes;

  PlanStepModel({
    this.time,
    required this.activityId,
    required this.activityTitle,
    this.venueName,
    this.centerName,
    this.notes,
  });

  factory PlanStepModel.fromJson(Map<String, dynamic> json) {
    return PlanStepModel(
      time: json['time'] as String?,
      activityId: json['activity_id'] as int,
      activityTitle: json['activity_title'] as String? ?? '',
      venueName: json['venue_name'] as String?,
      centerName: json['center_name'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class ChatMessageModel {
  final String role; // 'user' or 'assistant'
  final String content;
  final List<PlanStepModel>? plan;

  ChatMessageModel({required this.role, required this.content, this.plan});

  bool get isUser => role == 'user';
  bool get hasPlan => plan != null && plan!.isNotEmpty;

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}
