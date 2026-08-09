import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoItem({super.key, 
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomContainer(
          width: 40.w,
          height: 40.h,
          color: ColorManager.lightGreen.withOpacity(0.3),
          radius: 12.r,
          alignment: Alignment.center,
          child: Icon(icon, color: ColorManager.darkForestGreen, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(label, fontSize: 12.sp, color: ColorManager.gray),
            CustomText(value, fontSize: 15.sp, fontWeight: FontWeight.bold),
          ],
        ),
      ],
    );
  }
}