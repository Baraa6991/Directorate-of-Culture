import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/hall_booking_form_screen.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_data_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_data_state.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HallBookingDataScreen extends StatelessWidget {
  final String centerId;
  final String venueId;

  const HallBookingDataScreen({
    super.key,
    required this.centerId,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HallBookingDataCubit(
        repository: HomeRepository(),
      )..loadData(centerId: centerId, venueId: venueId),
      child: _HallBookingDataView(centerId: centerId, venueId: venueId),
    );
  }
}

class _HallBookingDataView extends StatelessWidget {
  final String centerId;
  final String venueId;

  const _HallBookingDataView({
    required this.centerId,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<HallBookingDataCubit, HallBookingDataState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: ColorManager.gray,
                          size: 44.sp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6C737F),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HallBookingDataCubit>().loadData(
                                  centerId: centerId,
                                  venueId: venueId,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.deepGreen,
                          ),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final center = state.center;
              final venue = state.venue;
              if (center == null || venue == null) {
                return const SizedBox.shrink();
              }

              final displayImage = venue.imageUrl.isNotEmpty
                  ? venue.imageUrl
                  : (center.photos.isNotEmpty ? center.photos.first : '');

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _BookingHeader(activeStep: 1),
                        SizedBox(height: 18.h),
                        const _SectionTitle(
                          title: 'بيانات القاعة',
                          subtitle: 'معلومات القاعة المحددة',
                        ),
                        SizedBox(height: 14.h),
                        _HallDataCard(
                          imageUrl: displayImage,
                          centerName: center.name,
                          centerLocation: center.location,
                          venueName: venue.name,
                          venueCapacity: venue.capacity,
                          venueFeatures: venue.features,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HallBookingFormScreen(
                                    venueId: venue.id,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.deepGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'التالي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HallDataCard extends StatelessWidget {
  final String imageUrl;
  final String centerName;
  final String centerLocation;
  final String venueName;
  final int venueCapacity;
  final List<String> venueFeatures;

  const _HallDataCard({
    required this.imageUrl,
    required this.centerName,
    required this.centerLocation,
    required this.venueName,
    required this.venueCapacity,
    required this.venueFeatures,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: imageUrl.isEmpty
                ? Image.asset(
                    AssetsManager.onboarding1Discover,
                    height: 175.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    height: 175.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        AssetsManager.onboarding1Discover,
                        height: 175.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          SizedBox(height: 12.h),
          _DataRow(
            label: 'اسم المركز',
            value: centerName,
            icon: Icons.apartment_rounded,
          ),
          SizedBox(height: 10.h),
          _DataRow(
            label: 'عنوان المركز',
            value: centerLocation,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 10.h),
          _DataRow(
            label: 'اسم القاعة',
            value: venueName,
            icon: Icons.meeting_room_outlined,
          ),
          SizedBox(height: 10.h),
          _DataRow(
            label: 'سعة القاعة',
            value: '$venueCapacity شخص',
            icon: Icons.groups_2_outlined,
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8EBEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted_rounded,
                      color: ColorManager.deepGreen,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'ميزات القاعة',
                      style: TextStyle(
                        color: Color(0xFF7A7F86),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: venueFeatures.isEmpty
                      ? const [
                          _FeatureChip(label: 'لا توجد ميزات متاحة حالياً'),
                        ]
                      : venueFeatures
                            .take(6)
                            .map((feature) => _FeatureChip(label: feature))
                            .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DataRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8EBEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF939AA3),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF1C1F24),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            height: 44.h,
            width: 44.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F6F7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorManager.deepGreen, size: 26.sp),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6ED),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF9BC6A6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ColorManager.deepGreen,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BookingHeader extends StatelessWidget {
  final int activeStep;

  const _BookingHeader({required this.activeStep});

  @override
  Widget build(BuildContext context) {
    final isStepOneActive = activeStep == 1;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorManager.deepGreen,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'طلب حجز قاعة',
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.deepGreen,
                  ),
                ),
              ),
            ),
            SizedBox(width: 48.w),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _StepNode(
                index: 1,
                title: 'بيانات القاعة',
                active: isStepOneActive,
              ),
            ),
            Container(
              height: 2.h,
              width: 100.w,
              color: const Color(0xFFD7DBDE),
            ),
            Expanded(
              child: _StepNode(
                index: 2,
                title: 'بيانات الطلب',
                active: !isStepOneActive,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  final int index;
  final String title;
  final bool active;

  const _StepNode({
    required this.index,
    required this.title,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 32.h,
          width: 32.w,
          decoration: BoxDecoration(
            color: active ? ColorManager.deepGreen : const Color(0xFFD5D8DD),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(
            color: active ? ColorManager.deepGreen : const Color(0xFF9CA3AB),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF20242A),
            fontSize: 38.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF939AA3),
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
