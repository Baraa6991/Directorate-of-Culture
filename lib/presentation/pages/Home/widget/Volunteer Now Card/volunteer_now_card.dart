import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class VolunteerNowCard extends StatelessWidget {
  const VolunteerNowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: ColorManager.darkForestGreen,
      radius: 24,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -10,
            child: CustomContainer(
              width: 90,
              height: 90,
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 50,
            child: CustomContainer(
              width: 18,
              height: 18,
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.volunteer_activism_outlined,
                  size: 32,
                  color: ColorManager.lightGreen,
                ),
                const SizedBox(height: 14),
                CustomText(
                  'Volunteer Now',
                  color: ColorManager.titleWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                const SizedBox(height: 8),
                CustomText(
                  'Join our community programs.',
                  color: ColorManager.subtitleGreen,
                  fontSize: 12,
                  height: 1.3,
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {},
                  backgroundColor: ColorManager.titleWhite,
                  foregroundColor: ColorManager.deepGreen,
                  radius: 30,
                  fixedSize: const Size(double.infinity, 44),
                  child: CustomText(
                    'تقديم الطلب',
                    color: ColorManager.deepGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
