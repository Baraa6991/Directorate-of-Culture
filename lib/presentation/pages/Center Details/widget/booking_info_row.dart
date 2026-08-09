import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool showDivider;

  const BookingInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorManager.lightGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: ColorManager.darkForestGreen),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(label, fontSize: 12.sp, color: ColorManager.gray),
                    SizedBox(height: 2.h),
                    CustomText(
                      value,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (showDivider) Divider(color: ColorManager.lightGray.withOpacity(0.3), height: 1.h),
      ],
    );
  }
}
