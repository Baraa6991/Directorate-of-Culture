import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileStatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ProfileStatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: ColorManager.titleWhite,
      radius: 16,
      paddingVertical: 14,
      paddingHorizontal: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ColorManager.deepGreen, size: 20.sp),
          SizedBox(height: 8.h),
          CustomText(
            value,
            color: ColorManager.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 2.h),
          CustomText(label, color: ColorManager.gray, fontSize: 11),
        ],
      ),
    );
  }
}
