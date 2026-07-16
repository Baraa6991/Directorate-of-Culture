import 'package:directorateofculture/presentation/pages/Auth/page/personal_info.dart';
import 'package:directorateofculture/presentation/pages/Splash/widget/DiamondShape.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Splash/widget/splash_bloc.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToPersonalInfo) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PersonalInfo()),
            );
          }
        },
        child: Scaffold(
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
                      const SizedBox(height: 70),
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
                      const SizedBox(height: 130),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: ColorManager.lightGreen,
                          ),
                          const SizedBox(width: 10),
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
        ),
      ),
    );
  }
}