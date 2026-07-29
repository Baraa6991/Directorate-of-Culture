// [EventModel.category] stays an internal English key (data layer, not
// user-facing) so it doesn't get entangled with display text. These two
// maps are the single source of truth for how a category is shown — the
// singular form (event details badge) and the plural filter-chip form,
// since Arabic plurals aren't a simple "+s" transform of the singular.
const Map<String, String> eventCategoryLabels = {
  'Workshop': 'ورشة عمل',
  'Lecture': 'محاضرة',
  'Exhibition': 'معرض',
};

const Map<String, String> eventCategoryFilterLabels = {
  'All': 'الكل',
  'Workshop': 'ورش العمل',
  'Lecture': 'محاضرات',
  'Exhibition': 'معارض',
};

class EventModel {
  final String id;
  final String title;
  final String category; // Workshop / Lecture / Exhibition
  final bool isLive;
  final String date;
  final String time;
  final String sessionLabel;
  final String location;
  final String locationDetail;
  final int? seatsAvailable;
  final String imageAsset;
  final String description;
  final bool isFreeEntry;
  final List<SpeakerInfo> speakers;
  final List<String> pastWorkshopImages;
  final double rating;
  final int reviewCount;
  final List<ReviewInfo> reviews;
  final bool isFavorite;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.imageAsset,
    this.isLive = false,
    this.sessionLabel = '',
    this.locationDetail = '',
    this.seatsAvailable,
    this.description = '',
    this.isFreeEntry = true,
    this.speakers = const [],
    this.pastWorkshopImages = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.reviews = const [],
    this.isFavorite = false,
  });

  EventModel copyWith({bool? isFavorite}) {
    return EventModel(
      id: id,
      title: title,
      category: category,
      isLive: isLive,
      date: date,
      time: time,
      sessionLabel: sessionLabel,
      location: location,
      locationDetail: locationDetail,
      seatsAvailable: seatsAvailable,
      imageAsset: imageAsset,
      description: description,
      isFreeEntry: isFreeEntry,
      speakers: speakers,
      pastWorkshopImages: pastWorkshopImages,
      rating: rating,
      reviewCount: reviewCount,
      reviews: reviews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SpeakerInfo {
  final String name;
  final String title;
  final String avatarAsset;

  const SpeakerInfo({
    required this.name,
    required this.title,
    required this.avatarAsset,
  });
}

class ReviewInfo {
  final String reviewerName;
  final String avatarAsset;
  final double rating;
  final String comment;

  const ReviewInfo({
    required this.reviewerName,
    required this.avatarAsset,
    required this.rating,
    required this.comment,
  });
}
