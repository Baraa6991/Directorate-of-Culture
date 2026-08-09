import 'package:directorateofculture/presentation/pages/Auth/page/personal_info.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/pages/Splash/widget/DiamondShape.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Splash/widget/splash_bloc.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          } else if (state is SplashNavigateToHome) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePageScreen()),
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
                    height: 130.h,
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
                      SizedBox(height: 70.h),
                      Image.asset(AssetsManager.logo),
                      SizedBox(height: 24.h),
                      CustomText(
                        'مديرية الثقافة',
                        fontSize: 30.sp,
                        color: ColorManager.titleWhite,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        'نبني جسراً بين التراث والابتكار',
                        color: ColorManager.subtitleGreen,
                      ),
                      SizedBox(height: 130.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: ColorManager.lightGreen,
                          ),
                          SizedBox(width: 10.w),
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