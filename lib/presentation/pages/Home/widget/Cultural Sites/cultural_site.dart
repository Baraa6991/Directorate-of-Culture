class CulturalSite {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final IconDataType iconType;
  final String activityLevel;
  final List<String> imageAssets;

  CulturalSite({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.iconType,
    required this.activityLevel,
    required this.imageAssets,
  });
}

enum IconDataType { theater, library, museum, pin }