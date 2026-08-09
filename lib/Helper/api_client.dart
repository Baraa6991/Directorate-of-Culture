import 'package:dio/dio.dart';
import 'package:directorateofculture/Helper/cach_helper.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
     final token = CacheHelper.getToken();
    _dio.options = BaseOptions(
      headers: {
        'Accept': 'application/json',
        if (token != null)
      'Authorization': 'Bearer $token',
      },
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
    );
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    return _handle(() => _dio.get(path, queryParameters: query));
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _handle(() => _dio.post(
          path,
          data: data,
          options: headers != null ? Options(headers: headers) : null,
        ));
  }

  Future<Map<String, dynamic>> postFormData(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    return _handle(
      () => _dio.post(path, data: FormData.fromMap(data)),
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
  }) async {
    return _handle(() => _dio.put(path, data: data));
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic data,
  }) async {
    return _handle(() => _dio.patch(path, data: data));
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
  }) async {
    return _handle(() => _dio.delete(path, data: data));
  }

  Future<Map<String, dynamic>> _handle(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(_arabicMessageFor(e));
    } catch (e) {
      // أي خطأ غير متوقع آخر (مثلاً تحويل بيانات فاشل) نلفّه أيضاً برسالة عربية عامة
      throw Exception('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.');
    }
  }

  /// يحوّل أي DioException (خطأ شبكة أو خطأ من الباك اند بأي كود حالة HTTP)
  /// إلى رسالة عربية واضحة ومفهومة للمستخدم، دون كشف تفاصيل تقنية.
  String _arabicMessageFor(DioException e) {
    // 1) أخطاء الشبكة/الاتصال (لا يوجد رد من السيرفر أصلاً)
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم، تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';
      case DioExceptionType.connectionError:
        return 'تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت.';
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب.';
      case DioExceptionType.badCertificate:
        return 'تعذّر التحقق من أمان الاتصال بالخادم.';
      case DioExceptionType.badResponse:
        break; // نتابع بالأسفل لتحليل كود الحالة
      case DioExceptionType.unknown:
        return 'تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت.';
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    final statusCode = e.response?.statusCode;
    final serverMessage = _extractServerMessage(e.response?.data);

    // 2) رسالة صريحة وواضحة قادمة من الباك اند (مثل أخطاء التحقق 422 المخصصة)
    //    نفضّلها دائماً إن وُجدت، لأنها أدق من الرسالة العامة لكود الحالة.
    if (serverMessage != null && serverMessage.trim().isNotEmpty) {
      return serverMessage;
    }

    // 3) رسائل عربية افتراضية حسب كود حالة HTTP عند غياب رسالة مخصصة
    switch (statusCode) {
      case 400:
        return 'الطلب غير صحيح، يرجى مراجعة البيانات المُدخلة.';
      case 401:
        return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى.';
      case 403:
        return 'لا تملك صلاحية للقيام بهذا الإجراء.';
      case 404:
        return 'العنصر المطلوب غير موجود.';
      case 409:
        return 'تعارض في البيانات، يرجى تحديث الصفحة والمحاولة مرة أخرى.';
      case 422:
        return 'يوجد خطأ في البيانات المُدخلة، يرجى التحقق منها.';
      case 429:
        return 'عدد المحاولات كبير جداً، يرجى الانتظار قليلاً قبل المحاولة مرة أخرى.';
      case 500:
        return 'حدث خطأ داخلي بالخادم، يرجى المحاولة لاحقاً.';
      case 502:
      case 503:
      case 504:
        return 'الخادم غير متاح حالياً، يرجى المحاولة بعد قليل.';
      default:
        return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.';
    }
  }

  /// يستخرج رسالة الخطأ من جسم الرد بمرونة، ويدعم بالأخص شكل أخطاء
  /// التحقق (Validation) القياسي بلارافيل عند 422:
  /// { "message": "...", "errors": { "phone": ["..."], "email": ["..."] } }
  /// في هذه الحالة نعرض أول رسالة تحقق فعلية بدل الرسالة العامة "The given data
  /// was invalid" غير المفيدة للمستخدم.
  String? _extractServerMessage(dynamic data) {
    if (data is! Map) return null;

    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstFieldErrors = errors.values.first;
      if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
        return firstFieldErrors.first.toString();
      }
      if (firstFieldErrors != null) {
        return firstFieldErrors.toString();
      }
    }

    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      // نتجاهل رسالة لارافيل الافتراضية غير المفيدة إن وُجدت بدون errors مفصّلة
      if (message == 'The given data was invalid.') return null;
      return message;
    }

    return null;
  }
}