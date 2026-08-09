class VenueModel {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final List<String> features;
  final String imageUrl;

  const VenueModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.features,
    required this.imageUrl,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final featuresList = (json['features'] as List<dynamic>? ?? [])
        .map((f) => f.toString())
        .toList();

    return VenueModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      features: featuresList,
      imageUrl: json['image'] as String? ?? '',
    );
  }
}