import 'package:directorateofculture/presentation/pages/Home/model/venue_model.dart';

class CenterDetailsModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final List<String> photos;
  final List<VenueModel> venues;

  const CenterDetailsModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.photos,
    required this.venues,
  });

  factory CenterDetailsModel.fromJson(Map<String, dynamic> json) {
    final photosList = (json['photos'] as List<dynamic>? ?? [])
        .map((p) => p['photo'] as String? ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    final venuesList = (json['venues'] as List<dynamic>? ?? [])
        .map((v) => VenueModel.fromJson(v as Map<String, dynamic>))
        .toList();

    return CenterDetailsModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photos: photosList,
      venues: venuesList,
    );
  }
}