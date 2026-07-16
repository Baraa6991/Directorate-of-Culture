import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.headers = {'Accept': 'application/json'};
    _dio.options.contentType = Headers.jsonContentType;

    // ممكن تضيف interceptors هنا (توكن، لوق، refresh token...)
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    return _handle(() => _dio.get(path, queryParameters: query));
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    return _handle(() => _dio.post(path, data: data));
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
      // معالجة موحدة للأخطاء (رسائل السيرفر، انقطاع الشبكة...)
      throw Exception(e.response?.data['message'] ?? 'حدث خطأ في الاتصال');
    }
  }
}