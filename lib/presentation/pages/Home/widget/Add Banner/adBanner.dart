import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBannerItem.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBanner_cubit.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdBanner extends StatelessWidget {
  final List<AdBannerItem> ads;

  const AdBanner({super.key, required this.ads});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdBannerCubit(ads),
      child: const _AdBannerView(),
    );
  }
}

class _AdBannerView extends StatefulWidget {
  const _AdBannerView();

  @override
  State<_AdBannerView> createState() => _AdBannerViewState();
}

class _AdBannerViewState extends State<_AdBannerView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdBannerCubit, AdBannerState>(
      listener: (context, state) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 240.h,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: state.ads.length,
                onPageChanged: (index) {
                  context.read<AdBannerCubit>().goToPage(index);
                },
                itemBuilder: (context, index) {
                  final ad = state.ads[index];
                  return _AdCard(ad: ad);
                },
              ),
              Positioned(
                bottom: 12.h,
                left: 0.w,
                right: 0.w,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: state.ads.length,
                    onDotClicked: (index) {
                      context.read<AdBannerCubit>().goToPage(index);
                    },
                    effect: ExpandingDotsEffect(
                      activeDotColor: ColorManager.deepGreen,
                      dotColor: ColorManager.titleWhite.withOpacity(0.6),
                      dotHeight: 6.h,
                      dotWidth: 6.w,
                      expansionFactor: 3,
                      spacing: 6.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdCard extends StatelessWidget {
  final AdBannerItem ad;

  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: NetworkImage(ad.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (ad.badgeText.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    ad.badgeText,
                    color: ColorManager.titleWhite,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
              ],
              CustomText(
                ad.title,
                color: ColorManager.titleWhite,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomText(
                ad.description,
                color: ColorManager.titleWhite,
                fontSize: 13.sp,
                height: 1.3,
              ),
              if (ad.dateText.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14.sp, color: ColorManager.titleWhite),
                    SizedBox(width: 6.w),
                    CustomText(ad.dateText, color: ColorManager.titleWhite, fontSize: 12.sp),
                  ],
                ),
              ],
              if (ad.locationText.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14.sp, color: ColorManager.titleWhite),
                    SizedBox(width: 6.w),
                    CustomText(ad.locationText, color: ColorManager.titleWhite, fontSize: 12.sp),
                  ],
                ),
              ],
              SizedBox(height: 14.h),
              CustomElevatedButton(
                onPressed: () {}, 
                backgroundColor: ColorManager.deepGreen,
                foregroundColor: ColorManager.titleWhite,
                radius: 22.r,
                paddingHorizontal: 22,
                paddingVertical: 10,
                child: CustomText(
                  ad.buttonText,
                  color: ColorManager.titleWhite,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
