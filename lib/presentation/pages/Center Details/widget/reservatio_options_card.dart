import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class ReservationOptionCart extends StatelessWidget {
  const ReservationOptionCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Full Center',
                color: ColorManager.darkForestGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorManager.lightGreen.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  'Recommended',
                  color: ColorManager.darkForestGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: ColorManager.gray),
              const SizedBox(width: 6),
              CustomText('Max 500 Guests', color: ColorManager.gray, fontSize: 13),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: ColorManager.gray),
              const SizedBox(width: 6),
              CustomText('00:00 - 22:00 (Full Day)', color: ColorManager.gray, fontSize: 13),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkForestGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: CustomText(
                'Select Option',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorManager.titleWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}