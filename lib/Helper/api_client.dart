import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.headers = {'Accept': 'application/json'};
    _dio.options.contentType = Headers.jsonContentType;
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    return _handle(() => _dio.get(path, queryParameters: query));
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    return _handle(() => _dio.post(path, data: data));
  }

  // ====================== POST FORM-DATA ======================
  Future<Map<String, dynamic>> postFormData(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    return _handle(
      () => _dio.post(path, data: FormData.fromMap(data)),
    );
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    return _handle(() => _dio.put(path, data: data));
  }

  Future<Map<String, dynamic>> delete(String path, {dynamic data}) async {
    return _handle(() => _dio.delete(path, data: data));
  }

  Future<Map<String, dynamic>> _handle(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ في الاتصال');
    }
  }
}