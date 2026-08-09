import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';
import 'package:directorateofculture/presentation/pages/AI/chat_message_model.dart';
import 'package:directorateofculture/presentation/pages/AI/comparison_result_model.dart';
import 'package:directorateofculture/presentation/pages/AI/recommendation_model.dart';
import 'package:directorateofculture/presentation/pages/Notification/model/notification_model.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Model/reservation_model.dart';

/// نتيجة سؤال المساعد الذكي (رسالة + خطة اختيارية)
class AssistantReply {
  final String message;
  final List<PlanStepModel>? plan;
  AssistantReply({required this.message, this.plan});
}

/// ريبوزيتوري موحّد لكل ما تبقّى: التطوع، حجوزات الفعاليات، حجوزات القاعات،
/// ومزايا الذكاء الاصطناعي الثلاث (المساعد، التوصيات، المقارنة).
class MiscRepository {
  final ApiClient _client;

  MiscRepository({ApiClient? client}) : _client = client ?? ApiClient();

  // ====================== التطوع ======================

  Future<Map<String, dynamic>> submitVolunteerForm({
    required Map<String, dynamic> data,
  }) {
    return _client.postFormData(ApiConstants.volunteer(), data: data);
  }

  // ====================== حجوزات الفعاليات ======================

  /// إنشاء حجز جديد لفعالية (POST /reservations)
  /// [idempotencyKey] يجب أن يكون نفس القيمة عند إعادة محاولة نفس الحجز
  /// (مثلاً بعد فشل مؤقت بالشبكة أو نقر مزدوج بالخطأ)، حتى يتعرّف الباك اند
  /// على أنها نفس المحاولة ولا ينشئ حجزاً مكرراً.
  Future<Map<String, dynamic>> createReservation({
    required Map<String, dynamic> data,
    String? idempotencyKey,
  }) {
    return _client.post(
      ApiConstants.reservations(),
      data: data,
      headers: idempotencyKey != null
          ? {'X-Idempotency-Key': idempotencyKey}
          : null,
    );
  }

  /// عرض تفاصيل حجز معيّن
  Future<Map<String, dynamic>> getReservation(String id) {
    return _client.get(ApiConstants.reservationDetails(id));
  }

  /// أرشيف حجوزات المستخدم — صفحة واحدة فقط (Infinite Scroll)، مع فلترة
  /// اختيارية بالحالة الخام بالباك اند (CONFIRMED / PENDING_PAYMENT /
  /// COMPLETED / CANCELLED) لتبويبات الأرشيف الأربعة.
  Future<List<ReservationModel>> getReservations({
    required int page,
    required int perPage,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (status != null) 'status': status,
    };
    final query = Uri(queryParameters: queryParams).query;
    final response = await _client.get('${ApiConstants.reservations()}?$query');

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ReservationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// إلغاء حجز
  Future<Map<String, dynamic>> cancelReservation(String id) {
    return _client.post(ApiConstants.cancelReservation(id));
  }

  // ====================== حجوزات القاعات ======================

  Future<Map<String, dynamic>> submitVenueReservation({
    required Map<String, dynamic> data,
  }) {
    return _client.postFormData(ApiConstants.venueReservations(), data: data);
  }

  // ====================== المساعد الذكي ======================

  Future<AssistantReply> askAssistant({
    required String message,
    List<ChatMessageModel> history = const [],
  }) async {
    final response = await _client.post(
      ApiConstants.assistantAsk(),
      data: {
        'message': message,
        'history': history.map((m) => m.toJson()).toList(),
      },
    );

    final planJson = response['plan'] as List<dynamic>?;

    return AssistantReply(
      message: response['message'] as String? ??
          'عذراً، لم أستطع الرد الآن، حاول مرة أخرى.',
      plan: planJson
          ?.map((e) => PlanStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // ====================== التوصيات الذكية (قد يعجبك) ======================

  Future<List<RecommendationModel>> getForYou({
    int limit = 5,
    bool refresh = false,
  }) async {
    final response = await _client.get(
      ApiConstants.aiForYou(),
      query: {
        'limit': limit,
        if (refresh) 'refresh': 1,
      },
    );

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ====================== المقارنة الذكية ======================

  /// [type] هو 'activity' أو 'center'
  Future<ComparisonResultModel> compare({
    required String type,
    required int id1,
    required int id2,
  }) async {
    final response = await _client.post(
      ApiConstants.aiCompare(),
      data: {
        'type': type,
        'ids': [id1, id2],
      },
    );

    return ComparisonResultModel.fromJson(response);
  }

  // ====================== الإشعارات ======================

  Future<List<NotificationModel>> getNotifications({required int page}) async {
    final response = await _client.get(
      '${ApiConstants.notifications()}?page=$page',
    );
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadNotificationsCount() async {
    final response = await _client.get(ApiConstants.notificationsUnreadCount());
    return int.tryParse(response['count']?.toString() ?? '') ?? 0;
  }

  Future<void> markNotificationAsRead(String id) {
    return _client.patch(ApiConstants.notificationMarkAsRead(id));
  }

  Future<void> markAllNotificationsAsRead() {
    return _client.post(ApiConstants.notificationsMarkAllAsRead());
  }

  Future<void> deleteNotification(String id) {
    return _client.delete(ApiConstants.notificationDelete(id));
  }
}