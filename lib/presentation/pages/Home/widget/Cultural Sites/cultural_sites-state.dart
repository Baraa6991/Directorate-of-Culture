import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_site.dart';

class CulturalSitesState {
  final List<CulturalSite> sites;
  final CulturalSite? selectedSite;
  final bool isLoading;
  final String? errorMessage;

  CulturalSitesState({
    required this.sites,
    this.selectedSite,
    this.isLoading = false,
    this.errorMessage,
  });

  CulturalSitesState copyWith({
    List<CulturalSite>? sites,
    CulturalSite? selectedSite,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CulturalSitesState(
      sites: sites ?? this.sites,
      selectedSite: selectedSite ?? this.selectedSite,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
