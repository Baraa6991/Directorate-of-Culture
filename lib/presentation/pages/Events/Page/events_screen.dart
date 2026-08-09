import 'dart:async';

import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/AI/compare_screen.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/events_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/events_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/event_card.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/event_details_screen.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ActivitiesCubit(repository: HomeRepository())..init(),
      child: const _ActivitiesView(),
    );
  }
}

class _ActivitiesView extends StatefulWidget {
  const _ActivitiesView();

  @override
  State<_ActivitiesView> createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends State<_ActivitiesView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  // ─── وضع المقارنة ───
  bool _compareMode = false;
  final Map<String, ActivityCardModel> _selected = {};

  @override
  void initState() {
    super.initState();
    // نراقب التمرير لنطلب الصفحة التالية تلقائياً قرب نهاية القائمة
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      context.read<ActivitiesCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // البحث يتنفذ بعد توقف المستخدم عن الكتابة بـ 400ms بدل كل حرف
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<ActivitiesCubit>().search(query);
    });
    // لتحديث زر المسح (X) فورًا بدون انتظار الـ debounce
    setState(() {});
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<ActivitiesCubit>().search('');
    setState(() {});
  }

  // ─── تفعيل/إلغاء وضع المقارنة ───
  void _toggleCompareMode() {
    setState(() {
      _compareMode = !_compareMode;
      if (!_compareMode) _selected.clear();
    });
  }

  void _toggleSelected(ActivityCardModel activity) {
    setState(() {
      if (_selected.containsKey(activity.id)) {
        _selected.remove(activity.id);
        return;
      }
      if (_selected.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يمكنك اختيار فعاليتين فقط للمقارنة')),
        );
        return;
      }
      _selected[activity.id] = activity;
    });
  }

  void _openComparison() {
    final items = _selected.values.toList();
    if (items.length != 2) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompareScreen(
          type: 'activity',
          id1: int.parse(items[0].id),
          title1: items[0].title,
          id2: int.parse(items[1].id),
          title2: items[1].title,
        ),
      ),
    ).then((_) {
      // نرجع نطفي وضع المقارنة بعد ما يرجع من شاشة النتيجة
      if (mounted) {
        setState(() {
          _compareMode = false;
          _selected.clear();
        });
      }
    });
  }

  // بوتوم شيت لاختيار قيمة الفلتر — مربوط بالكيوبت
  void _showOptionsSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String? selected,
    required String Function(String) labelBuilder,
    required void Function(String?) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.titleWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: CustomText(
                  title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const CustomText('الكل', color: ColorManager.black),
                trailing: selected == null
                    ? const Icon(Icons.check, color: ColorManager.deepGreen)
                    : null,
                onTap: () {
                  onSelect(null);
                  Navigator.pop(sheetContext);
                },
              ),
              ...options.map(
                (option) => ListTile(
                  title: CustomText(
                    labelBuilder(option),
                    color: ColorManager.black,
                  ),
                  trailing: selected == option
                      ? const Icon(Icons.check, color: ColorManager.deepGreen)
                      : null,
                  onTap: () {
                    onSelect(option);
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivitiesCubit>();

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              CustomText(
                'الفعاليات',
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.deepGreen,
              ),
              SizedBox(height: 16.h),

              // ─── حقل البحث (مربوط بالكيوبت مع debounce) ───
              CustomTextfield(
                controller: _searchController,
                hint: 'ابحث عن فعالية',
                hintColor: ColorManager.gray,
                filled: true,
                fillColor: ColorManager.titleWhite,
                prefixIcon: Icon(Icons.search, color: ColorManager.gray),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: _clearSearch,
                        child: Icon(Icons.close, color: ColorManager.gray),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                focusColor: ColorManager.deepGreen,
                onChanged: _onSearchChanged,
              ),
              SizedBox(height: 12.h),

              // ─── فلاتر الـ Dropdown ───
              BlocBuilder<ActivitiesCubit, ActivitiesState>(
                buildWhen: (prev, curr) =>
                    prev.selectedTypeId != curr.selectedTypeId ||
                    prev.selectedCenterId != curr.selectedCenterId ||
                    prev.typeOptions != curr.typeOptions ||
                    prev.centerOptions != curr.centerOptions,
                builder: (context, state) {
                  // نبحث عن التسمية الحقيقية للخيار المختار حالياً
                  final selectedTypeLabel = state.typeOptions
                      .where((o) => o.id == state.selectedTypeId)
                      .map((o) => o.label)
                      .cast<String?>()
                      .firstWhere((_) => true, orElse: () => null);

                  final selectedCenterLabel = state.centerOptions
                      .where((o) => o.id == state.selectedCenterId)
                      .map((o) => o.label)
                      .cast<String?>()
                      .firstWhere((_) => true, orElse: () => null);

                  return Row(
                    children: [
                      Expanded(
                        child: _DropdownField(
                          icon: Icons.tune,
                          label: selectedTypeLabel ?? 'نوع الفعالية',
                          onTap: () => _showOptionsSheet(
                            context: context,
                            title: 'نوع الفعالية',
                            options: state.typeOptions
                                .map((o) => o.id)
                                .toList(),
                            selected: state.selectedTypeId,
                            labelBuilder: (id) => state.typeOptions
                                .firstWhere((o) => o.id == id)
                                .label,
                            onSelect: cubit.selectType,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _DropdownField(
                          icon: Icons.location_on_outlined,
                          label: selectedCenterLabel ?? 'كل المراكز',
                          onTap: () => _showOptionsSheet(
                            context: context,
                            title: 'المركز',
                            options: state.centerOptions
                                .map((o) => o.id)
                                .toList(),
                            selected: state.selectedCenterId,
                            labelBuilder: (id) => state.centerOptions
                                .firstWhere((o) => o.id == id)
                                .label,
                            onSelect: cubit.selectCenter,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),

              // ─── عنوان القسم + زر تفعيل وضع المقارنة ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'القادمة إليك',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.black,
                  ),
                  TextButton.icon(
                    onPressed: _toggleCompareMode,
                    icon: Icon(
                      _compareMode ? Icons.close : Icons.compare_arrows,
                      size: 18.sp,
                      color: ColorManager.deepGreen,
                    ),
                    label: CustomText(
                      _compareMode ? 'إلغاء' : 'قارن',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.deepGreen,
                    ),
                  ),
                ],
              ),
              if (_compareMode)
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: CustomText(
                    'اختر فعاليتين لمقارنتهما (${_selected.length}/2)',
                    fontSize: 12.sp,
                    color: ColorManager.gray,
                  ),
                ),
              SizedBox(height: 12.h),

              Expanded(
                child: BlocBuilder<ActivitiesCubit, ActivitiesState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              state.errorMessage!,
                              color: ColorManager.gray,
                              fontSize: 13.sp,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            TextButton(
                              onPressed: cubit.loadFirstPage,
                              child: const CustomText(
                                'إعادة المحاولة',
                                color: ColorManager.deepGreen,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final activities = state.activities;

                    if (activities.isEmpty) {
                      return Center(
                        child: CustomText(
                          'لا توجد فعاليات',
                          color: ColorManager.gray,
                          fontSize: 14.sp,
                        ),
                      );
                    }

                    // عنصر إضافي بالنهاية لعرض مؤشر تحميل الصفحة التالية
                    final itemCount =
                        activities.length + (state.isLoadingMore ? 1 : 0);

                    return RefreshIndicator(
                      onRefresh: cubit.loadFirstPage,
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(bottom: 16.h),
                        itemCount: itemCount,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio:
                              0.52, 
                        ),
                        itemBuilder: (context, index) {
                          // آخر عنصر أثناء التحميل = مؤشر التحميل (يمتد عبر العمودين)
                          if (index >= activities.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          }

                          final activity = activities[index];

                          return _buildCard(
                            context: context,
                            activity: activity,
                            onBook: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailsScreen(
                                  activityId: int.parse(activity.id),
                                ),
                              ),
                            ),
                            onFavoriteToggle: () =>
                                cubit.toggleFavorite(activity.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // ─── شريط "قارن الآن" يظهر فقط لما يختار المستخدم فعاليتين ───
      bottomNavigationBar: (_compareMode && _selected.length == 2)
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openComparison,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.deepGreen,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: CustomText(
                      'قارن الآن',
                      color: ColorManager.titleWhite,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // ─── يبني الكارد العادي، أو الكارد + طبقة التحديد لو وضع المقارنة مفعّل ───
  Widget _buildCard({
    required BuildContext context,
    required ActivityCardModel activity,
    required VoidCallback onBook,
    required VoidCallback onFavoriteToggle,
  }) {
    final isSelected = _selected.containsKey(activity.id);

    // نمنع أزرار الكارد الداخلية (حجز/مفضلة) من استقبال اللمس أثناء وضع المقارنة
    // عشان اللمسة كاملة على الكارد تروح لتحديد/إلغاء تحديد الفعالية بدل فتحها.
    final card = IgnorePointer(
      ignoring: _compareMode,
      child: ActivityCard(
        activity: activity,
        onBook: onBook,
        onFavoriteToggle: onFavoriteToggle,
      ),
    );

    if (!_compareMode) return card;

    return GestureDetector(
      onTap: () => _toggleSelected(activity),
      child: Stack(
        children: [
          card,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? ColorManager.deepGreen
                        : Colors.transparent,
                    width: 3.w,
                  ),
                  color: isSelected
                      ? ColorManager.deepGreen.withOpacity(0.08)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.h,
            left: 8.w,
            child: CustomContainer(
              width: 26.w,
              height: 26.h,
              color: isSelected
                  ? ColorManager.deepGreen
                  : ColorManager.titleWhite,
              shape: BoxShape.circle,
              borderColor: ColorManager.deepGreen,
              borderWidth: 1.5,
              alignment: Alignment.center,
              child: isSelected
                  ? Icon(Icons.check, size: 16.sp, color: ColorManager.titleWhite)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ودجت الفلتر (Event Type / All Centers) ───
class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DropdownField({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        color: ColorManager.titleWhite,
        radius: 14.r,
        borderColor: ColorManager.lightGray,
        borderWidth: 1,
        paddingHorizontal: 12,
        paddingVertical: 12,
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: ColorManager.gray),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomText(
                label,
                fontSize: 13.sp,
                color: ColorManager.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.sp,
              color: ColorManager.gray,
            ),
          ],
        ),
      ),
    );
  }
}