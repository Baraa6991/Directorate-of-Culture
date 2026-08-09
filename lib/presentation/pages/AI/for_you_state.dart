part of 'for_you_cubit.dart';

class ForYouState {
  final List<RecommendationModel> recommendations;
  final bool isLoading;
  final String? errorMessage;

  ForYouState({
    this.recommendations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ForYouState copyWith({
    List<RecommendationModel>? recommendations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ForYouState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
