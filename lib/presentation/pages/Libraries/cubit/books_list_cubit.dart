import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:directorateofculture/repositories/library_repository.dart';
import 'books_list_state.dart';

class BooksListCubit extends Cubit<BooksListState> {
  final LibraryRepository repository;
  int currentPage = 1;
  String currentCategory = 'الكل';
  String currentSearch = '';

  // نحتفظ بآخر تصنيفات جبناها من الباك اند حتى نضلها ظاهرة بالواجهة
  // حتى أثناء التحميل أو لو رجع بحث نتيجة فاضية
  List<String> _lastCategories = [];

  BooksListCubit(this.repository) : super(BooksListInitial());

  Future<void> fetchBooks({String category = 'الكل'}) async {
    emit(BooksListLoading());
    try {
      currentPage = 1;
      currentCategory = category;
      final result = await repository.getBooks(
        page: currentPage,
        category: currentCategory,
        search: currentSearch,
      );

      if (result.categories.isNotEmpty) {
        _lastCategories = result.categories;
      }

      emit(BooksListLoaded(
        books: result.books,
        hasReachedMax: result.books.isEmpty || result.books.length < 10,
        selectedCategory: currentCategory,
        categories: _lastCategories,
        searchQuery: currentSearch,
      ));
    } catch (e) {
      emit(BooksListError(e.toString()));
    }
  }

  /// يستدعى من حقل البحث (مع debounce بالشاشة نفسها)
  Future<void> search(String query) async {
    emit(BooksListLoading());
    try {
      currentPage = 1;
      currentSearch = query;
      final result = await repository.getBooks(
        page: currentPage,
        category: currentCategory,
        search: currentSearch,
      );

      if (result.categories.isNotEmpty) {
        _lastCategories = result.categories;
      }

      emit(BooksListLoaded(
        books: result.books,
        hasReachedMax: result.books.isEmpty || result.books.length < 10,
        selectedCategory: currentCategory,
        categories: _lastCategories,
        searchQuery: currentSearch,
      ));
    } catch (e) {
      emit(BooksListError(e.toString()));
    }
  }

  Future<void> fetchMoreBooks() async {
    if (state is BooksListLoaded) {
      final currentState = state as BooksListLoaded;

      if (currentState.isFetchingMore || currentState.hasReachedMax) return;

      emit(currentState.copyWith(isFetchingMore: true));

      try {
        currentPage++;
        final result = await repository.getBooks(
          page: currentPage,
          category: currentCategory,
          search: currentSearch,
        );

        if (result.books.isEmpty) {
          emit(currentState.copyWith(isFetchingMore: false, hasReachedMax: true));
        } else {
          emit(BooksListLoaded(
            books: currentState.books + result.books,
            isFetchingMore: false,
            hasReachedMax: result.books.length < 10,
            selectedCategory: currentCategory,
            categories: currentState.categories,
            searchQuery: currentSearch,
          ));
        }
      } catch (e) {
        emit(currentState.copyWith(isFetchingMore: false));
      }
    }
  }
}