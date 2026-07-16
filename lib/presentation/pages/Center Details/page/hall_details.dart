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
                        height: 400,
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
                        height: 400,
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
                        top: 50,
                        left: 16,
                        right: 16,
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
                radius: 24,
                paddingAll: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    CustomText(
                      'Facilities & Support',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        FacilityChip(icon: Icons.wifi, label: 'Free WiFi'),
                        FacilityChip(
                          icon: Icons.local_cafe,
                          label: 'Premium Cafe',
                        ),
                        FacilityChip(
                          icon: Icons.local_parking,
                          label: 'Valet Parking',
                        ),
                        FacilityChip(
                          icon: Icons.accessible,
                          label: 'Accessibility Support',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ─── التاريخ والوقت ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocProvider(
                create: (_) => BookingCubit(
                  // مؤقتاً حتى يصل الباك اند
                  availableTimes: const [
                    '09:00 AM',
                    '11:30 AM',
                    '02:00 PM',
                    '04:30 PM',
                  ],
                ),
                child: const BookingDateTimePicker(),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                onPressed: () {},
                backgroundColor: ColorManager.deepGreen,
                foregroundColor: ColorManager.titleWhite,
                radius: 28,
                fixedSize: const Size(double.infinity, 58),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      'Next',
                      color: ColorManager.titleWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: 10.w),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
             const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
