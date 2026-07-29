import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? ColorManager.deepGreen
              : ColorManager.lightGreen.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
        ),
        child: CustomText(
          label,
          color: selected
              ? ColorManager.titleWhite
              : ColorManager.darkForestGreen,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
