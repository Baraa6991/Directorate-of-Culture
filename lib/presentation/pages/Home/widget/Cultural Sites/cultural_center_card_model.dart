class CulturalCenterCardModel {
  final String id;
  final String name;
  final String location;
  final String? mapLocation;
  final String description;
  final String imageUrl; // أول صورة من photos

  const CulturalCenterCardModel({
    required this.id,
    required this.name,
    required this.location,
    this.mapLocation,
    required this.description,
    required this.imageUrl,
  });

  factory CulturalCenterCardModel.fromJson(Map<String, dynamic> json) {
    // نأخذ أول صورة فقط من قائمة photos
    final photos = json['photos'] as List<dynamic>? ?? [];
    final firstPhoto = photos.isNotEmpty
        ? (photos.first['photo'] as String? ?? '')
        : '';

    return CulturalCenterCardModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      mapLocation: json['map_location'] as String?,
      description: json['description'] as String? ?? '',
      imageUrl: firstPhoto,
    );
  }
}
