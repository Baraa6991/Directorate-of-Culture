import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'user_profile_model.dart';

class ProfileMembershipCard extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileMembershipCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      radius: 20,
      paddingAll: 18,
      gradientColor1: ColorManager.darkForestGreen,
      gradientColor2: ColorManager.deepGreen,
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText(
                  'الهوية الرقمية',
                  color: ColorManager.subtitleGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.accentGreen.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7.sp,
                        color: ColorManager.accentGreen,
                      ),
                      SizedBox(width: 5.w),
                      Flexible(
                        child: CustomText(
                          'نشط',
                          color: ColorManager.titleWhite,
                          fontSize: 11,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          CustomText(
            profile.membershipTitle,
            color: ColorManager.titleWhite,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 18.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'رقم العضوية',
                      color: ColorManager.subtitleGreen,
                      fontSize: 11,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      profile.memberId,
                      color: ColorManager.titleWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                'تاريخ الانضمام',
                                color: ColorManager.subtitleGreen,
                                fontSize: 11,
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                profile.joinedDate,
                                color: ColorManager.titleWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                'تاريخ الانتهاء',
                                color: ColorManager.subtitleGreen,
                                fontSize: 11,
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                profile.expiresDate,
                                color: ColorManager.titleWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: ColorManager.titleWhite,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.qr_code_2,
                  color: ColorManager.darkForestGreen,
                  size: 32.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
