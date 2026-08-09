import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/page/volunteer_form_screen.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VolunteerNowCard extends StatelessWidget {
  const VolunteerNowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: ColorManager.darkForestGreen,
      radius: 24.r,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -10,
            child: CustomContainer(
              width: 90.w,
              height: 90.h,
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: 16.h,
            right: 50.w,
            child: CustomContainer(
              width: 18.w,
              height: 18.h,
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.volunteer_activism_outlined,
                  size: 32.sp,
                  color: ColorManager.lightGreen,
                ),
                SizedBox(height: 14.h),
                CustomText(
                  'تطوّع الآن',
                  color: ColorManager.titleWhite,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  'Join our community programs.',
                  color: ColorManager.subtitleGreen,
                  fontSize: 12.sp,
                  height: 1.3,
                ),
                SizedBox(height: 16.h),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VolunteerFormScreen(),
                      ),
                    );
                  },
                  backgroundColor: ColorManager.titleWhite,
                  foregroundColor: ColorManager.deepGreen,
                  radius: 30.r,
                  fixedSize: const Size(double.infinity, 44),
                  child: CustomText(
                    'تقديم الطلب',
                    color: ColorManager.deepGreen,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}