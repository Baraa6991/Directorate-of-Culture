import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/book_event_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BookEventCubit extends Cubit<BookEventState> {
  final MiscRepository repository;

  // مفتاح ثابت طوال عمر محاولة الحجز هذه (نفس الشاشة)، يُعاد إرساله بكل
  // محاولة (بما فيها إعادة المحاولة بعد فشل)، فيتعرّف الباك اند أنها نفس
  // الطلب ولا ينشئ حجزاً مكرراً حتى لو حدث نقر مزدوج أو تكرار بالشبكة.
  final String _idempotencyKey =
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';

  BookEventCubit({
    required this.repository,
    required ActivityCardModel activity,
  }) : super(BookEventState(activity: activity));

  void increment() {
    if (state.attendees < state.maxGuests) {
      emit(state.copyWith(attendees: state.attendees + 1));
    }
  }

  void decrement() {
    if (state.attendees > 1) {
      emit(state.copyWith(attendees: state.attendees - 1));
    }
  }

  Future<void> confirmBooking() async {
    if (state.seatsAvailable <= 0) {
      emit(state.copyWith(
        errorMessage: 'لا توجد مقاعد متاحة حالياً لهذه الفعالية',
      ));
      return;
    }

    if (state.attendees > state.seatsAvailable) {
      emit(state.copyWith(
        errorMessage: 'عدد الحضور المطلوب أكبر من المقاعد المتاحة',
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final activity = state.activity;
      final reservationDate = activity.startTime ?? DateTime.now();

      final payload = <String, dynamic>{
        'activity_id': int.tryParse(activity.id) ?? activity.id,
        if (activity.venueId != null && activity.venueId!.isNotEmpty)
          'venue_id': int.tryParse(activity.venueId!) ?? activity.venueId,
        'reservation_date': DateFormat('yyyy-MM-dd').format(reservationDate),
        'seats_count': state.attendees,
      };

      final response = await repository.createReservation(
        data: payload,
        idempotencyKey: _idempotencyKey,
      );
      final isSuccess = response['success'] == true ||
          response['success']?.toString() == 'true';

      if (isSuccess) {
        // الباك اند قد يرجّع الحجز مباشرة، أو (عند تفعيل allow_partial وتجزئة
        // الحجز) كائناً بداخله confirmed/wait_list. نلتقط دائماً الحجز
        // "المؤكَّد" لأنه هو الذي يحمل ticket_id + qr_payload الصالحين للعرض كـ QR.
        final rawData = response['data'];
        Map<String, dynamic>? reservation;
        if (rawData is Map) {
          final map = Map<String, dynamic>.from(rawData);
          if (map.containsKey('confirmed') && map['confirmed'] is Map) {
            reservation = Map<String, dynamic>.from(map['confirmed'] as Map);
          } else if (map.containsKey('ticket_id')) {
            reservation = map;
          }
        }

        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage:
              response['message'] as String? ?? 'تم تأكيد الحجز بنجاح',
          reservationData: reservation,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: response['message'] as String? ?? 'تعذر إتمام الحجز',
        ));
      }
    } catch (e) {
      debugPrint('💥 Book event submit error: $e');
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}