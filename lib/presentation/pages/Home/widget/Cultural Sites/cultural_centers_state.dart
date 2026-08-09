import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_center_card_model.dart';

class CulturalCentersState {
  final List<CulturalCenterCardModel> centers;
  final List<CulturalCenterCardModel> filteredCenters;
  final bool isLoading;
  final String query;
  final String? errorMessage;

  const CulturalCentersState({
    this.centers = const [],
    this.filteredCenters = const [],
    this.isLoading = false,
    this.query = '',
    this.errorMessage,
  });

  CulturalCentersState copyWith({
    List<CulturalCenterCardModel>? centers,
    List<CulturalCenterCardModel>? filteredCenters,
    bool? isLoading,
    String? query,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CulturalCentersState(
      centers: centers ?? this.centers,
      filteredCenters: filteredCenters ?? this.filteredCenters,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}