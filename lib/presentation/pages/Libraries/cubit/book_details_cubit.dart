import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:directorateofculture/repositories/library_repository.dart';
import 'package:directorateofculture/presentation/pages/Libraries/model/book_model.dart';

abstract class BookDetailsState {}

class BookDetailsInitial extends BookDetailsState {}
class BookDetailsLoading extends BookDetailsState {}
class BookDetailsLoaded extends BookDetailsState {
  final BookModel book;
  BookDetailsLoaded(this.book);
}
class BookDetailsError extends BookDetailsState {
  final String message;
  BookDetailsError(this.message);
}

class BookDetailsCubit extends Cubit<BookDetailsState> {
  final LibraryRepository repository;

  BookDetailsCubit(this.repository) : super(BookDetailsInitial());

  Future<void> fetchBookDetails(int bookId) async {
    emit(BookDetailsLoading());
    try {
      final book = await repository.getBookDetails(bookId);
      emit(BookDetailsLoaded(book));
    } catch (e) {
      emit(BookDetailsError(e.toString()));
    }
  }
}