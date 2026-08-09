import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/center_details_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/center_details_state.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Facility.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/carousel_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/reservatio_options_card.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CenterDetails extends StatelessWidget {
  final String centerId;

  const CenterDetails({super.key, required this.centerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CenterDetailsCubit(
        repository: HomeRepository(),
      )..loadCenter(centerId),
      child: const _CenterDetailsView(),
    );
  }
}

// ─────────────────────────────────────────────
class _CenterDetailsView extends StatelessWidget {
  const _CenterDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterDetailsCubit, CenterDetailsState>(
      builder: (context, state) {
        // ── Loading ──
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ── Error ──
        if (state.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      color: ColorManager.gray, size: 48.sp),
                  SizedBox(height: 12.h),
                  CustomText(state.errorMessage!,
                      color: ColorManager.gray, fontSize: 14.sp),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CenterDetailsCubit>().loadCenter(
                              (context
                                      .read<CenterDetailsCubit>()
                                      .repository)
                                  .toString(),
                            ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Data ──
        final center = state.center!;
        final photos = center.photos;

        return Scaffold(
          backgroundColor: ColorManager.titleWhite,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Carousel ──
                BlocProvider(
                  create: (_) => CarouselCubit(
                    photos.isNotEmpty ? photos : [''],
                  ),
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
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                return _NetworkImage(url: photos[index]);
                              },
                            ),
                          ),
                          // gradient
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
                          // back + favourite
                          Positioned(
                            top: 50.h,
                            left: 16.w,
                            right: 16.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: ColorManager.titleWhite,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.black),
                                    onPressed: () =>
                                        Navigator.pop(context),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: ColorManager.titleWhite,
                                  child: const Icon(Icons.favorite_border,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          // name + location overlay
                          Positioned(
                            bottom: 40.h,
                            left: 20.w,
                            right: 20.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  center.name,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.titleWhite,
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: ColorManager.titleWhite,
                                        size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: CustomText(
                                        center.location,
                                        fontSize: 13.sp,
                                        color: ColorManager.titleWhite
                                            .withOpacity(0.9),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // dots indicator
                          if (photos.length > 1)
                            Positioned(
                              bottom: 16.h,
                              left: 0.w,
                              right: 0.w,
                              child: BlocBuilder<CarouselCubit, int>(
                                builder: (context, current) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(photos.length, (i) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                                        width: i == current ? 18 : 6,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: i == current
                                              ? ColorManager.titleWhite
                                              : ColorManager.titleWhite
                                                  .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                // ── White card ──
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
                        // Description
                        CustomText(
                          center.description,
                          fontSize: 13.sp,
                          color: ColorManager.gray,
                        ),
                        SizedBox(height: 20.h),
                        Divider(
                            color:
                                ColorManager.lightGray.withOpacity(0.4)),
                        SizedBox(height: 12.h),
                        // Venues summary as "Facilities" chips
                        CustomText(
                          'القاعات والمرافق',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.darkForestGreen,
                        ),
                        SizedBox(height: 14.h),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: center.venues.map((v) {
                            return FacilityChip(
                              icon: _venueIcon(v.type),
                              label: v.name,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Venues (Reservation Options) ──
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomText(
                    'خيارات الحجز',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.darkForestGreen,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: center.venues.map((venue) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: ReservationOptionCart(
                          venue: venue,
                          centerId: center.id,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _venueIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hall':
        return Icons.meeting_room_outlined;
      case 'theater':
        return Icons.theaters_outlined;
      case 'gallery':
        return Icons.photo_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}

// ─────────────────────────────────────────────
class _NetworkImage extends StatelessWidget {
  final String url;
  const _NetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _fallback(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: ColorManager.lightBackground,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _fallback() => Container(
        color: ColorManager.lightBackground,
        child: Center(
          child: Icon(
            Icons.account_balance_outlined,
            color: ColorManager.deepGreen.withOpacity(0.45),
            size: 48.sp,
          ),
        ),
      );
}