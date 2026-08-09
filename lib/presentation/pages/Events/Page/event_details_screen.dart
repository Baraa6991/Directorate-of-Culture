import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/event_details_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/event_details_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/book_event_screen.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  final int activityId;

  const EventDetailsScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventDetailsCubit(
        repository: HomeRepository(),
        activityId: activityId,
      )..loadActivity(),
      child: const _EventDetailsView(),
    );
  }
}

class _EventDetailsView extends StatelessWidget {
  const _EventDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
        builder: (context, state) {
          if (state is EventDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventDetailsError) {
            return SafeArea(
              child: Column(
                children: [
                  _BackButtonBar(),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              state.message,
                              color: ColorManager.gray,
                              fontSize: 13.sp,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            TextButton(
                              onPressed: () => context
                                  .read<EventDetailsCubit>()
                                  .loadActivity(),
                              child: const CustomText(
                                'إعادة المحاولة',
                                color: ColorManager.deepGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final activity = (state as EventDetailsLoaded).activity;

          return Stack(
            children: [
              // ─── محتوى الشاشة القابل للتمرير ───
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 80.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── صورة الغلاف + أزرار الرجوع والمفضلة ───
                    Stack(
                      children: [
                        Image.network(
                          activity.imageUrl,
                          height: 260.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 260.h,
                                color: ColorManager.lightGray.withOpacity(0.3),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: ColorManager.gray,
                                ),
                              ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 260.h,
                              color: ColorManager.lightGray.withOpacity(0.2),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          right: 8.w,
                          child: SafeArea(
                            bottom: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _CircleIconButton(
                                  icon: Icons.arrow_back,
                                  onTap: () => Navigator.pop(context),
                                ),
                                _CircleIconButton(
                                  icon: Icons.favorite_border,
                                  onTap: () {
                                    // اربطها لاحقًا بتوگل المفضلة إذا احتجت
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ─── بطاقة المحتوى فوق الصورة ───
                    Transform.translate(
                      offset: Offset(0, -20.h),
                      child: CustomContainer(
                        color: ColorManager.lightBackground,
                        radius: 24.r,
                        paddingHorizontal: 20,
                        paddingVertical: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // شارة النوع
                            CustomContainer(
                              color: ColorManager.deepGreen,
                              radius: 20.r,
                              paddingHorizontal: 12,
                              paddingVertical: 5,
                              child: CustomText(
                                activity.typeLabel,
                                color: ColorManager.titleWhite,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // العنوان
                            CustomText(
                              activity.title,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.black,
                            ),
                            SizedBox(height: 14.h),

                            // التاريخ والوقت
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16.sp,
                                  color: ColorManager.deepGreen,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        activity.dateLabel,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.black,
                                      ),
                                      CustomText(
                                        _weekdayLabel(activity.startTime),
                                        fontSize: 12.sp,
                                        color: ColorManager.gray,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomText(
                                  activity.timeLabel,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.black,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            // الموقع
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16.sp,
                                  color: ColorManager.deepGreen,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: CustomText(
                                    activity.locationLabel,
                                    fontSize: 13.sp,
                                    color: ColorManager.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 22.h),

                            // ─── About Event ───
                            CustomText(
                              'عن الفعالية',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.black,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              activity.description,
                              fontSize: 13.sp,
                              color: ColorManager.gray,
                            ),

                            // ─── Speakers (تظهر فقط إذا فيه محاضر) ───
                            if (activity.presenterName != null &&
                                activity.presenterName!.isNotEmpty) ...[
                              SizedBox(height: 22.h),
                              CustomText(
                                'المتحدثون',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.black,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22.r,
                                    backgroundColor: ColorManager.lightGray
                                        .withOpacity(0.4),
                                    backgroundImage:
                                        activity.presenterAvatar != null
                                        ? NetworkImage(
                                            activity.presenterAvatar!,
                                          )
                                        : null,
                                    child: activity.presenterAvatar == null
                                        ? Icon(
                                            Icons.person,
                                            color: ColorManager.gray,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomText(
                                    activity.presenterName!,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorManager.black,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── شريط سفلي ثابت: Free Entry + Book Now فقط ───
              Positioned(
                left: 0.w,
                right: 0.w,
                bottom: 0.h,
                child: SafeArea(
                  top: false,
                  child: CustomContainer(
                    color: ColorManager.titleWhite,
                    paddingHorizontal: 20,
                    paddingVertical: 14,
                    shadowColor: ColorManager.black.withOpacity(0.08),
                    shadowBlurRadius: 12,
                    shadowOffset: const Offset(0, -4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                _priceLabel(activity.ticketPrice),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.deepGreen,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 160.w,
                          child: CustomElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookEventScreen(activity: activity),
                                ),
                              );
                            },
                            backgroundColor: ColorManager.deepGreen,
                            radius: 12.r,
                            paddingVertical: 14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'احجز الآن',
                                  color: ColorManager.titleWhite,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: ColorManager.titleWhite,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _weekdayLabel(DateTime? date) {
    if (date == null) return '';
    return DateFormat('EEEE').format(date);
  }

  String _priceLabel(num? price) {
    if (price == null || price == 0) return 'دخول مجاني';
    return '$price ريال';
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        width: 38.w,
        height: 38.h,
        color: ColorManager.black.withOpacity(0.35),
        shape: BoxShape.circle,
        alignment: Alignment.center,
        child: Icon(icon, color: ColorManager.titleWhite, size: 18.sp),
      ),
    );
  }
}

class _BackButtonBar extends StatelessWidget {
  const _BackButtonBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: ColorManager.black),
          ),
        ],
      ),
    );
  }
}
