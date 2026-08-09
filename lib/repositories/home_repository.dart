import 'package:directorateofculture/Constant/Apis.dart';
import 'package:directorateofculture/Helper/api_client.dart';
import 'package:directorateofculture/presentation/pages/Home/model/center_details_model.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_center_card_model.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/events_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';

/// ريبوزيتوري موحّد لكل ما يخص: الشاشة الرئيسية، المراكز الثقافية، والفعاليات.
class HomeRepository {
  final ApiClient _client;

  HomeRepository({ApiClient? client}) : _client = client ?? ApiClient();

  // ====================== الشاشة الرئيسية ======================

  Future<Map<String, dynamic>> getProfile() {
    return _client.get(ApiConstants.profile());
  }

  Future<Map<String, dynamic>> getAds() {
    return _client.get(ApiConstants.ads());
  }

  // ====================== الفعاليات القادمة/القديمة (مُرقّمة) ======================

  Future<Map<String, dynamic>> getComingActivities({
    int page = 1,
    int perPage = 5,
  }) {
    return _client.get(
      ApiConstants.comingActivities(),
      query: {'page': page, 'per_page': perPage},
    );
  }

  Future<Map<String, dynamic>> getFinishedActivities({
    int page = 1,
    int perPage = 5,
  }) {
    return _client.get(
      ApiConstants.finishedActivities(),
      query: {'page': page, 'per_page': perPage},
    );
  }

  // ====================== المراكز الثقافية ======================

  Future<List<CulturalCenterCardModel>> getCenters() async {
    final response = await _client.get(ApiConstants.culturalCenters());

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => CulturalCenterCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CenterDetailsModel> getCenterDetails(String id) async {
    final response = await _client.get(ApiConstants.culturalCenterDetails(id));
    final data = response['data'] as Map<String, dynamic>;
    return CenterDetailsModel.fromJson(data);
  }

  // ====================== الفعاليات (قائمة مُرقّمة + تفاصيل + فلاتر) ======================

  /// يجلب صفحة واحدة فقط (وليس كل البيانات) — للاستخدام مع Infinite Scroll.
  /// الفلاتر (search / centerId / activityTypeId) تُطبَّق من السيرفر مباشرة
  /// لأن ActivityController::index تدعمها أصلاً كـ query params.
  Future<List<ActivityCardModel>> getActivities({
    required int page,
    required int perPage,
    String? search,
    String? centerId,
    String? activityTypeId,
  }) async {
    final queryParams = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (centerId != null) 'center_id': centerId,
      if (activityTypeId != null) 'activity_type_id': activityTypeId,
    };

    final query = Uri(queryParameters: queryParams).query;
    final response = await _client.get('${ApiConstants.activities()}?$query');

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ActivityCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// جلب فعالية واحدة بالتفصيل عبر GET /activities/{id}
  /// (endpoint مخصص - أسرع بكثير من تحميل كل الفعاليات والبحث محلياً)
  ///
  /// ⚠️ لا تستخدم ApiConstants.activities() هنا: تلك الدالة تُستخدم لقائمة
  /// "القادمة" وتشير فعلياً إلى /activities/coming. نستخدم بدلاً منها
  /// ApiConstants.activityDetails() المخصصة لمسار /activities/{id}.
  Future<ActivityCardModel> getActivityById(int id) async {
    final response = await _client.get(ApiConstants.activityDetails('$id'));

    // JsonResource المفرد يُغلَّف تلقائياً بمفتاح 'data'
    final data = response['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('لم يتم العثور على الفعالية');
    }
    return ActivityCardModel.fromJson(data);
  }

  Future<List<FilterOption>> getActivityTypeOptions() async {
    final response = await _client.get(ApiConstants.activityTypes());

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => FilterOption(
              id: e['id'].toString(),
              label: e['title']?.toString() ?? '',
            ))
        .toList();
  }

  Future<List<FilterOption>> getCenterOptions() async {
    final response = await _client.get(ApiConstants.centers());

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => FilterOption(
              id: e['id'].toString(),
              label: e['name']?.toString() ?? '',
            ))
        .toList();
  }
}
