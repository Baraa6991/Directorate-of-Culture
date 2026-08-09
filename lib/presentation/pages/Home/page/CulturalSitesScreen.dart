import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_site.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_sites-state.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_sites_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/center_details.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CulturalSitesScreen extends StatelessWidget {
  const CulturalSitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CulturalSitesCubit(repository: HomeRepository())
            ..loadSites(),
      child: const _CulturalSitesView(),
    );
  }
}

class _CulturalSitesView extends StatelessWidget {
  const _CulturalSitesView();

  IconData _iconFor(IconDataType type) {
    switch (type) {
      case IconDataType.theater:
        return Icons.theater_comedy_outlined;
      case IconDataType.library:
        return Icons.menu_book_outlined;
      case IconDataType.museum:
        return Icons.museum_outlined;
      case IconDataType.pin:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  CustomText(
                    'المواقع الثقافية',
                    color: ColorManager.deepGreen,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CulturalSitesCubit, CulturalSitesState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: ColorManager.gray,
                              size: 40.sp,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              state.errorMessage!,
                              color: ColorManager.gray,
                              fontSize: 14.sp,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.sites.isEmpty) {
                    return Center(
                      child: CustomText(
                        'لا توجد مراكز لعرضها على الخريطة',
                        color: ColorManager.gray,
                        fontSize: 14.sp,
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            state.selectedSite?.latitude ??
                                state.sites.first.latitude,
                            state.selectedSite?.longitude ??
                                state.sites.first.longitude,
                          ),
                          initialZoom: 13,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                            subdomains: const ['a', 'b', 'c', 'd'],
                            userAgentPackageName:
                                'com.directorateofculture.app',
                          ),
                          MarkerLayer(
                            markers: state.sites.map((site) {
                              final isSelected =
                                  state.selectedSite?.id == site.id;
                              return Marker(
                                point: LatLng(site.latitude, site.longitude),
                                width: isSelected ? 140 : 100,
                                height: isSelected ? 104 : 84,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<CulturalSitesCubit>()
                                        .selectSite(site);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: isSelected ? 52 : 40,
                                        height: isSelected ? 52 : 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? ColorManager.deepGreen
                                              : ColorManager.mediumGreen,
                                          border: isSelected
                                              ? Border.all(
                                                  color: ColorManager.lightGreen
                                                      .withOpacity(0.5),
                                                  width: 6.w,
                                                )
                                              : null,
                                        ),
                                        child: Icon(
                                          _iconFor(site.iconType),
                                          color: ColorManager.titleWhite,
                                          size: isSelected ? 22 : 18,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: isSelected ? 140 : 100,
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                        decoration: BoxDecoration(
                                          color: ColorManager.titleWhite,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.08,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: CustomText(
                                          site.name,
                                          color: ColorManager.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      if (state.selectedSite != null)
                        Positioned(
                          left: 0.w,
                          right: 0.w,
                          bottom: 0.h,
                          child: _SelectedSiteCard(site: state.selectedSite!),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedSiteCard extends StatelessWidget {
  final CulturalSite site;

  const _SelectedSiteCard({required this.site});

  Color _activityColor() {
    switch (site.activityLevel) {
      case 'نشاط مرتفع':
        return const Color(0xFFFFE6C2);
      case 'نشاط متوسط':
        return const Color(0xFFFFF3C2);
      default:
        return const Color(0xFFE6ECE3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _activityColor(),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8.sp, color: Colors.orange),
                SizedBox(width: 6.w),
                CustomText(
                  site.activityLevel,
                  color: ColorManager.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          CustomText(
            site.name,
            color: ColorManager.deepGreen,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 14.h),
          CustomElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CenterDetails(centerId: site.id),
                ),
              );
            },
            backgroundColor: ColorManager.deepGreen,
            foregroundColor: ColorManager.titleWhite,
            radius: 26.r,
            fixedSize: const Size(1000, 50),
            child: CustomText(
              'الانتقال إلى المركز',
              color: ColorManager.titleWhite,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: site.imageAssets.map((asset) {
              final isLast = asset == site.imageAssets.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      asset,
                      height: 70.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 70.h,
                          color: ColorManager.lightBackground,
                          child: Icon(
                            Icons.image_outlined,
                            color: ColorManager.gray,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
