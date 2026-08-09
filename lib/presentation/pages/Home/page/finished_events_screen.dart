import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cubit/finished_activities_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Past%20Events/past_events_cart.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// شاشة "الفعاليات القديمة" الكاملة — نفس تصميم كروت الرئيسية،
/// بدون بحث أو فلترة، مع ترقيم صفحات (زر "التالي") تماماً كما بالشاشة الرئيسية.
class FinishedEventsScreen extends StatelessWidget {
  const FinishedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinishedActivitiesCubit(repository: HomeRepository())
        ..loadFirstPage(),
      child: const _FinishedEventsView(),
    );
  }
}

class _FinishedEventsView extends StatelessWidget {
  const _FinishedEventsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.black),
        title: CustomText(
          'الفعاليات القديمة',
          color: ColorManager.deepGreen,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<FinishedActivitiesCubit, FinishedActivitiesState>(
        builder: (context, state) {
          if (state.isLoading && state.activities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.activities.isEmpty) {
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
                    onPressed: () =>
                        context.read<FinishedActivitiesCubit>().loadFirstPage(),
                    child: const CustomText(
                      'إعادة المحاولة',
                      color: ColorManager.deepGreen,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.activities.isEmpty) {
            return Center(
              child: CustomText(
                'لا توجد فعاليات سابقة',
                color: ColorManager.gray,
                fontSize: 14.sp,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<FinishedActivitiesCubit>().loadFirstPage(),
            child: ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: state.activities.length + 1, // +1 لزر "التالي" بالأسفل
              separatorBuilder: (context, index) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                if (index == state.activities.length) {
                  // ─── زر التالي (نفس نمط الشاشة الرئيسية بالضبط) ───
                  if (!state.hasMore) return const SizedBox.shrink();

                  return Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Center(
                      child: TextButton(
                        onPressed: state.isLoadingMore
                            ? null
                            : () => context
                                .read<FinishedActivitiesCubit>()
                                .loadNextPage(),
                        child: state.isLoadingMore
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    'التالي',
                                    color: ColorManager.deepGreen,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16.sp,
                                    color: ColorManager.deepGreen,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }

                return PastEventsCart(activity: state.activities[index]);
              },
            ),
          );
        },
      ),
    );
  }
}