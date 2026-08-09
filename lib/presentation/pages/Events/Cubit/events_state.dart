import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';

// خيار بسيط لعرض id + اسم قابل للعرض (نوع فعالية أو مركز)
class FilterOption {
  final String id;
  final String label;
  const FilterOption({required this.id, required this.label});
}

class ActivitiesState {
  // القائمة المتراكمة من كل الصفحات المحمّلة حتى الآن
  final List<ActivityCardModel> activities;

  final bool isLoading;      // تحميل أول صفحة (أو إعادة تحميل كامل بعد تغيير فلتر)
  final bool isLoadingMore;  // تحميل صفحة إضافية أثناء التمرير للأسفل
  final int currentPage;
  final bool hasMore;        // هل توجد صفحات أخرى بالسيرفر

  final String query;
  // نفلتر بالـ id دائمًا (وليس بنص الاسم) لأن الأسماء قد تتغير/تكون ديناميكية
  final String? selectedTypeId;
  final String? selectedCenterId;

  // القوائم الحقيقية القادمة من الباك اند (تُحمّل مرة واحدة عند فتح الشاشة)
  final List<FilterOption> typeOptions;
  final List<FilterOption> centerOptions;

  final String? errorMessage;

  const ActivitiesState({
    this.activities = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.query = '',
    this.selectedTypeId,
    this.selectedCenterId,
    this.typeOptions = const [],
    this.centerOptions = const [],
    this.errorMessage,
  });

  ActivitiesState copyWith({
    List<ActivityCardModel>? activities,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasMore,
    String? query,
    String? selectedTypeId,
    bool clearType = false,
    String? selectedCenterId,
    bool clearCenter = false,
    List<FilterOption>? typeOptions,
    List<FilterOption>? centerOptions,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      selectedTypeId:
          clearType ? null : (selectedTypeId ?? this.selectedTypeId),
      selectedCenterId:
          clearCenter ? null : (selectedCenterId ?? this.selectedCenterId),
      typeOptions: typeOptions ?? this.typeOptions,
      centerOptions: centerOptions ?? this.centerOptions,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}