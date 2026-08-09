import 'package:directorateofculture/Helper/api_client.dart';
import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/presentation/pages/Libraries/model/book_model.dart';

/// كل ما يخص المكتبات والكتب.
class LibraryRepository {
  final ApiClient _client;

  LibraryRepository({ApiClient? client}) : _client = client ?? ApiClient();

  // جلب قائمة الكتب + التصنيفات الحقيقية الموجودة بقاعدة البيانات
  Future<({List<BookModel> books, List<String> categories})> getBooks({
    int page = 1,
    String? category,
    String? search,
  }) async {
    String url = '${ApiConstants.books}?page=$page';
    if (category != null && category != 'الكل') {
      url += '&category=${Uri.encodeQueryComponent(category)}';
    }
    if (search != null && search.trim().isNotEmpty) {
      url += '&search=${Uri.encodeQueryComponent(search.trim())}';
    }

    final response = await _client.get(url);

    final books = (response['data'] as List<dynamic>? ?? [])
        .map((json) => BookModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final categories = (response['categories'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return (books: books, categories: categories);
  }

  // جلب تفاصيل كتاب محدد
  Future<BookModel> getBookDetails(int id) async {
    final response = await _client.get('${ApiConstants.books}/$id');
    if (response['data'] != null) {
      return BookModel.fromJson(response['data']);
    }
    throw Exception('بيانات الكتاب غير متوفرة');
  }
}
