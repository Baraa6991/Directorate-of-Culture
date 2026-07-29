import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "الفعاليات / المراكز الثقافية" underline tab toggle at the top of
/// ArchiveScreen. Visually distinct from CategoryFilterChip (pill chips), so
/// kept as its own feature-local widget rather than reused.
class ArchiveTabToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const ArchiveTabToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final selected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                CustomText(
                  labels[index],
                  color: selected ? ColorManager.deepGreen : ColorManager.gray,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 2.h,
                  color: selected ? ColorManager.deepGreen : Colors.transparent,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
