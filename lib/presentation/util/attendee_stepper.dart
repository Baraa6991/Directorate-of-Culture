import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Generic "- count +" stepper. Not Events-specific — reusable anywhere a
/// bounded integer quantity needs to be picked (attendees, tickets, items...).
class AttendeeStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const AttendeeStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove,
          filled: false,
          onTap: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(width: 18.w),
        CustomText(
          '$value',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorManager.black,
        ),
        SizedBox(width: 18.w),
        _StepperButton(
          icon: Icons.add,
          filled: true,
          onTap: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, required this.filled, this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 32.w,
        height: 32.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled
              ? (disabled ? ColorManager.lightGray : ColorManager.deepGreen)
              : Colors.transparent,
          border: filled
              ? null
              : Border.all(color: ColorManager.lightGray, width: 1.2),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: filled ? ColorManager.titleWhite : ColorManager.gray,
        ),
      ),
    );
  }
}
