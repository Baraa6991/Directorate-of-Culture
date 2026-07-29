import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class PlaceholderTabScreen extends StatelessWidget {
  final IconData icon;
  final String title;

  const PlaceholderTabScreen({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ColorManager.lightGray),
            const SizedBox(height: 12),
            CustomText(
              title,
              color: ColorManager.gray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomText(
              'Coming soon',
              color: ColorManager.lightGray,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
