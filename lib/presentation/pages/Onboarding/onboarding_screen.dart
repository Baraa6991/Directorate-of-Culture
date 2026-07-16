import 'package:directorateofculture/presentation/pages/Onboarding/Onboarding1-Discover.dart';
import 'package:directorateofculture/presentation/pages/Onboarding/Onboarding2-Discover.dart';
import 'package:directorateofculture/presentation/pages/Onboarding/Onboarding3Discover.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: PageView(
        controller: pageController,
        children: [
          Onboarding1Discover(pageController: pageController, onNext: _nextPage),
          Onboarding2Discover(pageController: pageController, onNext: _nextPage),
          Onboarding3Discover(pageController: pageController, onNext: () {}),
        ],
      ),
    );
  }
}