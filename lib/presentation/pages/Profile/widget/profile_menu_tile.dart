import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One settings row (icon, title, optional trailing value, chevron) grouped
/// under a section header on ProfileScreen.
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: ColorManager.deepGreen),
            SizedBox(width: 14.w),
            Expanded(
              child: CustomText(
                title,
                color: ColorManager.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (trailingText != null) ...[
              Flexible(
                child: CustomText(
                  trailingText!,
                  color: ColorManager.gray,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 6.w),
            ],
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: ColorManager.lightGray,
            ),
          ],
        ),
      ),
    );
  }
}
