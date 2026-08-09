import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_form_state.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HallBookingFormCubit extends Cubit<HallBookingFormState> {
  final MiscRepository repository;

  HallBookingFormCubit({required this.repository})
      : super(const HallBookingFormState());

  void updateRequestingParty(String value) {
    emit(state.copyWith(requestingParty: value, errorMessage: null));
  }

  void updateApplicantName(String value) {
    emit(state.copyWith(applicantName: value, errorMessage: null));
  }

  void updateNationalIdNumber(String value) {
    emit(state.copyWith(nationalIdNumber: value, errorMessage: null));
  }

  void updateReservationReason(String value) {
    emit(state.copyWith(reservationReason: value, errorMessage: null));
  }

  void updateEventDescription(String value) {
    emit(state.copyWith(eventDescription: value, errorMessage: null));
  }

  void updateIsPublic(bool value) {
    emit(state.copyWith(isPublic: value, errorMessage: null));
  }

  void updateStartDateTime(DateTime value) {
    emit(state.copyWith(startDateTime: value, errorMessage: null));
  }

  void updateEndDateTime(DateTime value) {
    emit(state.copyWith(endDateTime: value, errorMessage: null));
  }

  Future<void> submit({required String venueId}) async {
    if (state.requestingParty.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال اسم الجهة الطالبة'));
      return;
    }
    if (state.applicantName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال اسم مقدم الطلب'));
      return;
    }
    if (state.nationalIdNumber.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال الرقم الوطني'));
      return;
    }
    if (state.reservationReason.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال سبب الحجز'));
      return;
    }
    if (state.eventDescription.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال وصف الفعالية'));
      return;
    }
    if (state.startDateTime == null) {
      emit(state.copyWith(errorMessage: 'الرجاء اختيار وقت البدء'));
      return;
    }
    if (state.endDateTime == null) {
      emit(state.copyWith(errorMessage: 'الرجاء اختيار وقت الانتهاء'));
      return;
    }
    if (state.endDateTime!.isBefore(state.startDateTime!)) {
      emit(state.copyWith(errorMessage: 'وقت الانتهاء يجب أن يكون بعد وقت البدء'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final format = DateFormat('yyyy-MM-dd HH:mm:ss');
      final payload = <String, dynamic>{
        'venue_id': venueId,
        'requesting_party': state.requestingParty.trim(),
        'applicant_name': state.applicantName.trim(),
        'national_id_number': state.nationalIdNumber.trim(),
        'reservation_reason': state.reservationReason.trim(),
        'event_description': state.eventDescription.trim(),
        'is_public': state.isPublic ? 1 : 0,
        'start_time': format.format(state.startDateTime!),
        'end_time': format.format(state.endDateTime!),
      };

      final response = await repository.submitVenueReservation(data: payload);
      final isSuccess = response['success'] == true ||
          response['success']?.toString() == 'true' ||
          response['status'] == 'success';

      if (isSuccess) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: response['message'] ?? 'تم إرسال طلب الحجز بنجاح',
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: response['message'] ?? 'تعذر إرسال طلب الحجز',
        ));
      }
    } catch (e) {
      debugPrint('Hall booking submit error: $e');
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
