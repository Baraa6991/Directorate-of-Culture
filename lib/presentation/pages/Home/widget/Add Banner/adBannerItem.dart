class AdBannerItem {
  final String imageUrl;
  final String title;
  final String description;
  final String badgeText;
  final String dateText;
  final String locationText;
  final String buttonText;

  AdBannerItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.badgeText = '',
    this.dateText = '',
    this.locationText = '',
    this.buttonText = 'احجز الآن',
  });
}

class AdBannerState {
  final List<AdBannerItem> ads;
  final int currentIndex;

  AdBannerState({
    required this.ads,
    this.currentIndex = 0,
  });

  AdBannerState copyWith({
    List<AdBannerItem>? ads,
    int? currentIndex,
  }) {
    return AdBannerState(
      ads: ads ?? this.ads,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}