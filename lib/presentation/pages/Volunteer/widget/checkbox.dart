import 'package:flutter/material.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CheckboxRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;
  final bool compact;

  const CheckboxRow({
    super.key,
    required this.label,
    required this.checked,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: compact ? 4 : 8),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: checked ? ColorManager.deepGreen : Colors.transparent,
                border: Border.all(
                  color: checked
                      ? ColorManager.deepGreen
                      : ColorManager.subtitleGreen,
                  width: 1.5.w,
                ),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: checked
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10.w),
            CustomText(label, color: ColorManager.black, fontSize: 13.sp),
          ],
        ),
      ),
    );
  }
}