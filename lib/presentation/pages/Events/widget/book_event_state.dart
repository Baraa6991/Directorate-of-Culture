class BookEventState {
  final int attendeeCount;

  const BookEventState({this.attendeeCount = 1});

  BookEventState copyWith({int? attendeeCount}) {
    return BookEventState(attendeeCount: attendeeCount ?? this.attendeeCount);
  }
}
