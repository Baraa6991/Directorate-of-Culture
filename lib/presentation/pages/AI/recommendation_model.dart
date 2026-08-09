import 'package:directorateofculture/presentation/pages/Home/model/activity_model.dart';

class RecommendationModel {
  final ActivityModel activity;
  final String reason;

  RecommendationModel({required this.activity, required this.reason});

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      activity: ActivityModel.fromJson(
        json['activity'] as Map<String, dynamic>,
      ),
      reason: json['reason'] as String? ?? '',
    );
  }
}
