import 'package:directorateofculture/presentation/util/assets_manager.dart';
import 'package:directorateofculture/presentation/util/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding2Discover extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onNext;

  const Onboarding2Discover({
    super.key,
    required this.pageController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerRight,
            child: CustomText("Skip", color: ColorManager.black, fontSize: 20),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.asset(AssetsManager.onboarding2Discover),
          ),
          const SizedBox(height: 20),
          CustomText(
            "Easy Event Booking",
            color: ColorManager.deepGreen,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          CustomText(
            "Reserve your seat in seconds with\na simple booking experience.",
            color: ColorManager.deepGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: ColorManager.deepGreen,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: onNext,
            backgroundColor: ColorManager.deepGreen,
            foregroundColor: ColorManager.titleWhite,
            radius: 30,
            fixedSize: const Size(double.infinity, 55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Next",
                  color: ColorManager.titleWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
