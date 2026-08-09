import 'package:flutter/material.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                title,
                color: ColorManager.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 8.w),
              Icon(icon, color: ColorManager.deepGreen, size: 18.sp),
            ],
          ),
          Divider(color: Color(0xFFE6ECE3), height: 18.h),
          child,
        ],
      ),
    );
  }
}