import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({List<String> availableTimes = const []})
      : super(
          BookingState(
            focusedDay: DateTime.now(),
            availableTimes: availableTimes,
          ),
        );

  void selectDate(DateTime selectedDay, DateTime focusedDay) {
    emit(state.copyWith(
      selectedDate: selectedDay,
      focusedDay: focusedDay,
      selectedTime: null, // إعادة ضبط الوقت عند تغيير اليوم
    ));
    // لاحقاً: استدعِ الباك اند هنا لجلب أوقات هذا اليوم تحديداً
    // final times = await api.getAvailableTimes(selectedDay);
    // updateAvailableTimes(times);
  }

  void onPageChanged(DateTime focusedDay) {
    emit(state.copyWith(focusedDay: focusedDay));
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }

  void updateAvailableTimes(List<String> times) {
    emit(state.copyWith(availableTimes: times, selectedTime: null));
  }
}
