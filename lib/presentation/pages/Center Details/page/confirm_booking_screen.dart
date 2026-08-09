import 'package:directorateofculture/presentation/pages/Center%20Details/widget/FacilityModel.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/booking_info_row.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/hall_feature_item.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = const [
      FacilityModel(iconKey: 'stage_lighting', label: 'المسرح والإضاءة'),
      FacilityModel(iconKey: 'ac', label: 'تكييف الهواء'),
      FacilityModel(iconKey: 'sound_system', label: 'نظام الصوت'),
      FacilityModel(iconKey: 'seating', label: 'مقاعد (120)'),
      FacilityModel(iconKey: 'projector', label: 'جهاز عرض وشاشة'),
      FacilityModel(iconKey: 'microphone', label: 'ميكروفونات'),
      FacilityModel(iconKey: 'wifi', label: 'واي فاي'),
      FacilityModel(iconKey: 'parking', label: 'موقف سيارات متاح'),
    ];

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.titleWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: ColorManager.darkForestGreen),
        ),
        title: CustomText(
          'تأكيد حجزك',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.darkForestGreen,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20.r,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'مركز العين الثقافي',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      'قاعة المسرح',
                      fontSize: 13.sp,
                      color: ColorManager.gray,
                    ),
                    SizedBox(height: 8.h),
                    BookingInfoRow(
                      icon: Icons.apartment,
                      label: 'المركز',
                      value: 'مركز العين الثقافي',
                    ),
                    BookingInfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'القاعة',
                      value: 'قاعة المسرح',
                    ),
                    BookingInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'التاريخ',
                      value: '20 أكتوبر 2024',
                    ),
                    BookingInfoRow(
                      icon: Icons.access_time,
                      label: 'الوقت',
                      value: '19:00 - 22:00',
                    ),
                    BookingInfoRow(
                      icon: Icons.groups_outlined,
                      label: 'السعة',
                      value: '120 Seats',
                    ),
                    BookingInfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'رقم الحجز',
                      value: 'ACC-2024-1020-TH-01',
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20.r,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'مرافق ومميزات القاعة',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    SizedBox(height: 16.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 3.2,
                          ),
                      itemBuilder: (context, index) {
                        return HallFeatureItem(feature: features[index]);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20.r,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'معلوماتك',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      'أدخل بياناتك لتأكيد الحجز',
                      fontSize: 12.sp,
                      color: ColorManager.gray,
                    ),
                    SizedBox(height: 18.h),

                    CustomText(
                      'الاسم الكامل',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextfield(
                      hint: 'أدخل اسمك الكامل',
                      hintColor: ColorManager.lightGray,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),

                    SizedBox(height: 16.h),
                    CustomText(
                      'رقم الهاتف',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextfield(
                      hint: '05X XXX XXXX',
                      hintColor: ColorManager.lightGray,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),

                    SizedBox(height: 16.h),
                    CustomText(
                      'الرقم الوطني',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextfield(
                      hint: '784-XXXX-XXXXXXX-X',
                      hintColor: ColorManager.lightGray,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {},
                  backgroundColor: ColorManager.darkForestGreen,
                  radius: 28.r,
                  fixedSize: const Size(double.infinity, 58),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        'تأكيد الحجز',
                        color: ColorManager.titleWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14.sp,
                      color: ColorManager.gray,
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      'معلوماتك آمنة ومشفّرة',
                      fontSize: 11.sp,
                      color: ColorManager.gray,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
