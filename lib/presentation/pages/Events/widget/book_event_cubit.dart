import 'package:flutter_bloc/flutter_bloc.dart';

import 'book_event_state.dart';

class BookEventCubit extends Cubit<BookEventState> {
  BookEventCubit() : super(const BookEventState());

  void setAttendeeCount(int count) {
    emit(state.copyWith(attendeeCount: count));
  }
}
