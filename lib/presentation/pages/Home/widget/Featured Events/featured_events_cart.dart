import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class FeaturedEventsCart extends StatelessWidget {
  const FeaturedEventsCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.gray,width: 1.5),
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  AssetsManager.onboarding1Discover,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.accentGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    'LIVE NOW',
                    color: ColorManager.titleWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Arabian Calligraphy Exhibition',
                  color: ColorManager.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: ColorManager.black,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      'Oct 24 • 18:00 - 21:00',
                      color: ColorManager.black,
                      fontSize: 13,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: ColorManager.black,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      'National Arts Center',
                      color: ColorManager.black,
                      fontSize: 13,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                CustomElevatedButton(
                  onPressed: () {},
                  backgroundColor: ColorManager.deepGreen,
                  foregroundColor: ColorManager.titleWhite,
                  radius: 24,
                  fixedSize: const Size(double.infinity, 46),
                  child: CustomText(
                    'Book Now',
                    color: ColorManager.titleWhite,
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