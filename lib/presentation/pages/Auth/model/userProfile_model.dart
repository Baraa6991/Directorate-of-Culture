class UserProfileModel {
  final int id;
  final String name;
  final String phone;
  final DateTime? dateOfBirth;
  final String? gender; // male / female
  final String? avatarUrl;
  final int completedEventsCount;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
    required this.completedEventsCount,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : null,
      gender: json['gender']?.toString(),
      avatarUrl: json['avatar']?.toString(),
      completedEventsCount:
          int.tryParse(json['completed_events_count']?.toString() ?? '') ?? 0,
    );
  }
}