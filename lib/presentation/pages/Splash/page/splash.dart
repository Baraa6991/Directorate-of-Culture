import 'package:directorateofculture/presentation/pages/Splash/widget/DiamondShape.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.darkForestGreen,
      body: SafeArea(
        child: Column(
          children: [
            ClipRect(
              child: SizedBox(
                width: double.infinity,
                height: 130,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => DiamondPattern(
                      color: index == 2
                          ? ColorManager.mediumGreen
                          : ColorManager.deepGreen,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Image.asset(AssetsManager.logo),
                  const SizedBox(height: 24),
                  CustomText(
                    "Directorate of Culture",
                    fontSize: 30,
                    color: ColorManager.titleWhite,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    "Bridging Heritage and Innovation",
                    color: ColorManager.subtitleGreen,
                  ),
                  SizedBox(height: 130),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: ColorManager.lightGreen,
                      ),
                      SizedBox(width: 10,),
                      Icon(
                        Icons.verified_user_outlined,
                        color: ColorManager.lightGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
