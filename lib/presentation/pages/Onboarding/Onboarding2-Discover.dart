import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding2Discover extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onNext;

  const Onboarding2Discover({
    super.key,
    required this.pageController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Align(
            alignment: Alignment.centerRight,
            child: CustomText('تخطي', color: ColorManager.black, fontSize: 20.sp),
          ),
          SizedBox(height: 30.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(26.r),
            child: Image.asset(AssetsManager.onboarding2Discover),
          ),
          SizedBox(height: 20.h),
          CustomText(
            'حجز الفعاليات بسهولة',
            color: ColorManager.deepGreen,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10.h),
          CustomText(
            'احجز مقعدك خلال ثوانٍ\nبتجربة حجز سهلة وبسيطة.',
            color: ColorManager.deepGreen,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: ColorManager.deepGreen,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
            ),
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            onPressed: onNext,
            backgroundColor: ColorManager.deepGreen,
            foregroundColor: ColorManager.titleWhite,
            radius: 30.r,
            fixedSize: const Size(double.infinity, 55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  'التالي',
                  color: ColorManager.titleWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
