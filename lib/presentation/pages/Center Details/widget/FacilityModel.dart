class FacilityModel {
  final String iconKey; // مثال: "wifi", "cafe", "parking", "accessibility"
  final String label;

  const FacilityModel({
    required this.iconKey,
    required this.label,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      iconKey: json['icon'] as String? ?? 'default',
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'icon': iconKey,
        'label': label,
      };
}