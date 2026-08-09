import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VolunteerSuccessScreen extends StatelessWidget {
  final String message;

  const VolunteerSuccessScreen({super.key, required this.message});

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePageScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const Spacer(),
                  Opacity(
                    opacity: 0.08,
                    child: Image.asset(
                      AssetsManager.onboarding1Discover,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220.h,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _goHome(context),
                        icon: const Icon(Icons.close, color: ColorManager.black),
                      ),
                      const Spacer(),
                      CustomText(
                        'المنصة الثقافية',
                        color: ColorManager.deepGreen,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const Spacer(flex: 2),
                  Container(
                    width: 106.w,
                    height: 106.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.lightGreen.withOpacity(0.25),
                    ),
                    child: Center(
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.deepGreen,
                        ),
                        child: Icon(
                          Icons.check,
                          color: ColorManager.subtitleGreen,
                          size: 50.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.titleWhite,
                      borderRadius: BorderRadius.circular(26.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'تم إرسال طلبك بنجاح',
                          color: ColorManager.deepGreen,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        CustomText(
                          message,
                          color: ColorManager.gray,
                          fontSize: 14.sp,
                          height: 1.6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 26.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: ColorManager.lightBackground,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                color: ColorManager.deepGreen,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomText(
                                  'سيصلك إشعار فور مراجعة الطلب وتحديد الخطوات التالية.',
                                  color: ColorManager.gray,
                                  fontSize: 13.sp,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h),
                        CustomElevatedButton(
                          onPressed: () => _goHome(context),
                          backgroundColor: ColorManager.deepGreen,
                          foregroundColor: ColorManager.titleWhite,
                          radius: 30.r,
                          fixedSize: const Size(double.infinity, 56),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                'العودة للرئيسية',
                                color: ColorManager.titleWhite,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(width: 10.w),
                              Icon(
                                Icons.home_outlined,
                                color: ColorManager.titleWhite,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}