class BookingState {
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<String> availableTimes;

  const BookingState({
    required this.focusedDay,
    this.selectedDate,
    this.selectedTime,
    this.availableTimes = const [],
  });

  BookingState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDate,
    String? selectedTime,
    List<String>? availableTimes,
  }) {
    return BookingState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      availableTimes: availableTimes ?? this.availableTimes,
    );
  }
}