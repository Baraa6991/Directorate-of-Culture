import 'package:directorateofculture/presentation/pages/Home/model/center_details_model.dart';
import 'package:directorateofculture/presentation/pages/Home/model/venue_model.dart';

class HallBookingDataState {
  final bool isLoading;
  final CenterDetailsModel? center;
  final VenueModel? venue;
  final String? errorMessage;

  const HallBookingDataState({
    this.isLoading = false,
    this.center,
    this.venue,
    this.errorMessage,
  });

  HallBookingDataState copyWith({
    bool? isLoading,
    CenterDetailsModel? center,
    VenueModel? venue,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HallBookingDataState(
      isLoading: isLoading ?? this.isLoading,
      center: center ?? this.center,
      venue: venue ?? this.venue,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
