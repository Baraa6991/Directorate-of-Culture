import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_data_state.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';

class HallBookingDataCubit extends Cubit<HallBookingDataState> {
  final HomeRepository repository;

  HallBookingDataCubit({required this.repository})
      : super(const HallBookingDataState());

  Future<void> loadData({
    required String centerId,
    required String venueId,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final center = await repository.getCenterDetails(centerId);
      final venueIndex = center.venues.indexWhere((item) => item.id == venueId);
      final venue = venueIndex == -1 ? null : center.venues[venueIndex];

      if (venue == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'لم يتم العثور على القاعة المطلوبة',
        ));
        return;
      }

      emit(state.copyWith(
        isLoading: false,
        center: center,
        venue: venue,
      ));
    } catch (e) {
      debugPrint('HallBookingData load error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
