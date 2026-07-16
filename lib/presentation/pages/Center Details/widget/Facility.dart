import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class FacilityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const FacilityChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radius: 30,
      color: ColorManager.lightBackground,
      paddingHorizontal: 14,
      paddingVertical: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ColorManager.darkForestGreen),
          const SizedBox(width: 6),
          CustomText(label, fontSize: 13),
        ],
      ),
    );
  }
}