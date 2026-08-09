import 'package:directorateofculture/presentation/pages/Libraries/model/book_model.dart';

abstract class BooksListState {}

class BooksListInitial extends BooksListState {}

class BooksListLoading extends BooksListState {}

class BooksListLoaded extends BooksListState {
  final List<BookModel> books;
  final bool isFetchingMore;
  final bool hasReachedMax;
  final String selectedCategory;
  final List<String> categories;
  final String searchQuery;

  BooksListLoaded({
    required this.books,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.selectedCategory = 'الكل',
    this.categories = const [],
    this.searchQuery = '',
  });

  BooksListLoaded copyWith({
    List<BookModel>? books,
    bool? isFetchingMore,
    bool? hasReachedMax,
    String? selectedCategory,
    List<String>? categories,
    String? searchQuery,
  }) {
    return BooksListLoaded(
      books: books ?? this.books,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class BooksListError extends BooksListState {
  final String message;
  BooksListError(this.message);
}