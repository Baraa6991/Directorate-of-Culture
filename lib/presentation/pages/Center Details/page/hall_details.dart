import 'package:directorateofculture/presentation/pages/Center Details/widget/Facility.dart';
import 'package:directorateofculture/presentation/pages/Center Details/widget/carousel_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/booking_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/booking_date_time_picker.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HallDetails extends StatelessWidget {
  const HallDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      AssetsManager.logo,
      AssetsManager.onboarding1Discover,
      AssetsManager.onboarding1Discover,
    ];

    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── الصور ─────────────────────────────────────
            BlocProvider(
              create: (_) => CarouselCubit(images),
              child: Builder(
                builder: (context) {
                  final cubit = context.read<CarouselCubit>();
                  return Stack(
                    children: [
                      SizedBox(
                        height: 400.h,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: cubit.controller,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 400.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              ColorManager.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50.h,
                        left: 16.w,
                        right: 16.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: ColorManager.titleWhite,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: ColorManager.titleWhite,
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ─── الميزات ─────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -24),
              child: CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 24.r,
                paddingAll: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    CustomText(
                      'Facilities & Support',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    SizedBox(height: 14.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        FacilityChip(icon: Icons.wifi, label: 'واي فاي مجاني'),
                        FacilityChip(
                          icon: Icons.local_cafe,
                          label: 'مقهى مميز',
                        ),
                        FacilityChip(
                          icon: Icons.local_parking,
                          label: 'خدمة صف السيارات',
                        ),
                        FacilityChip(
                          icon: Icons.accessible,
                          label: 'دعم ذوي الاحتياجات الخاصة',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ─── التاريخ والوقت ────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocProvider(
                create: (_) => BookingCubit(
                  // مؤقتاً حتى يصل الباك اند
                  availableTimes: const [
                    '09:00 ص',
                    '11:30 ص',
                    '02:00 م',
                    '04:30 م',
                  ],
                ),
                child: const BookingDateTimePicker(),
              ),
            ),

            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomElevatedButton(
                onPressed: () {},
                backgroundColor: ColorManager.deepGreen,
                foregroundColor: ColorManager.titleWhite,
                radius: 28.r,
                fixedSize: const Size(double.infinity, 58),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      'التالي',
                      color: ColorManager.titleWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: 10.w),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
             SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
