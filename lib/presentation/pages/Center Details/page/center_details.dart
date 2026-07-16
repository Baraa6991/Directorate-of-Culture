import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Facility.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/InfoItem.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/carousel_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/reservatio_options_card.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CenterDetails extends StatelessWidget {
  const CenterDetails({super.key});

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

                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Al Ain Cultural Center',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.titleWhite,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: ColorManager.titleWhite,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: CustomText(
                                    'Hazza Bin Zayed St, Al Ain, UAE',
                                    fontSize: 13,
                                    color: ColorManager.titleWhite.withOpacity(
                                      0.9,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
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
                    // Capacity + Open Hours
                    Row(
                      children: [
                        InfoItem(
                          icon: Icons.groups,
                          label: 'Capacity',
                          value: '500+',
                        ),
                        const SizedBox(width: 40),
                        InfoItem(
                          icon: Icons.access_time,
                          label: 'Open Hours',
                          value: '09:00 - 22:00',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: ColorManager.lightGray.withOpacity(0.4)),
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                'Reservation Options',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorManager.darkForestGreen,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(4, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: ReservationOptionCart(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
