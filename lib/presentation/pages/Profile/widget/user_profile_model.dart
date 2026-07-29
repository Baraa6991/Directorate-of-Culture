class UserProfileModel {
  final String name;
  final String membershipTier;
  final String membershipTitle;
  final String memberId;
  final String joinedDate;
  final String expiresDate;
  final int eventsCount;
  final double hoursVolunteered;
  final int points;

  const UserProfileModel({
    required this.name,
    required this.membershipTier,
    required this.membershipTitle,
    required this.memberId,
    required this.joinedDate,
    required this.expiresDate,
    required this.eventsCount,
    required this.hoursVolunteered,
    required this.points,
  });
}
