import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_site.dart';

class CulturalSitesState {
  final List<CulturalSite> sites;
  final CulturalSite? selectedSite;

  CulturalSitesState({
    required this.sites,
    this.selectedSite,
  });

  CulturalSitesState copyWith({
    List<CulturalSite>? sites,
    CulturalSite? selectedSite,
  }) {
    return CulturalSitesState(
      sites: sites ?? this.sites,
      selectedSite: selectedSite ?? this.selectedSite,
    );
  }
}