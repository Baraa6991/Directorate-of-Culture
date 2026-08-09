import 'package:directorateofculture/presentation/pages/Home/model/center_details_model.dart';


class CenterDetailsState {
  final CenterDetailsModel? center;
  final bool isLoading;
  final String? errorMessage;

  const CenterDetailsState({
    this.center,
    this.isLoading = false,
    this.errorMessage,
  });

  CenterDetailsState copyWith({
    CenterDetailsModel? center,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CenterDetailsState(
      center: center ?? this.center,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}