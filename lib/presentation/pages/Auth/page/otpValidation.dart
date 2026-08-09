import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/otp_validation_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class Otpvalidation extends StatelessWidget {
  final String phone;
  final OtpFlowType flow;

  const Otpvalidation({
    super.key,
    required this.phone,
    this.flow = OtpFlowType.register,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpValidationCubit(repository: AuthRepository()),
      child: _OtpValidationView(phone: phone, flow: flow),
    );
  }
}

class _OtpValidationView extends StatelessWidget {
  final String phone;
  final OtpFlowType flow;

  const _OtpValidationView({required this.phone, required this.flow});

  @override
  Widget build(BuildContext context) {
    final currentCode = ValueNotifier<String>('');

    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocListener<OtpValidationCubit, OtpValidationState>(
            listener: (context, state) {
              if (state is OtpValidationSuccess) {
                AppSnackBar.show(context, state.message);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomePageScreen()),
                  (route) => false,
                );
              } else if (state is OtpValidationError) {
                AppSnackBar.show(context, state.message, success: false);
              } else if (state is OtpResendSuccess) {
                AppSnackBar.show(context, state.message);
              } else if (state is OtpResendError) {
                AppSnackBar.show(context, state.message, success: false);
              }
            },
            child: Column(
              children: [
                SizedBox(height: 100.h),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(height: 150.h),
                CustomText(
                  'تحقق من رقمك',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  textAlign: TextAlign.center,
                  color: ColorManager.black,
                ),
                SizedBox(height: 15.h),
                CustomText(
                  'أدخل رمز التحقق المكوّن من 6 أرقام\nالمرسل إلى هاتفك.',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                  color: ColorManager.black,
                ),
                SizedBox(height: 40.h),
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 60.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(19.r),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 60.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.deepGreen, width: 2.w),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onCompleted: (pin) {
                    currentCode.value = pin;
                  },
                ),
                SizedBox(height: 40.h),
                BlocBuilder<OtpValidationCubit, OtpValidationState>(
                  builder: (context, state) {
                    final isLoading = state is OtpValidationLoading;
                    return CustomElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<OtpValidationCubit>().verifyOtp(
                                    phone: phone,
                                    code: currentCode.value,
                                    flow: flow,
                                  );
                            },
                      backgroundColor: ColorManager.deepGreen,
                      foregroundColor: ColorManager.titleWhite,
                      radius: 30.r,
                      fixedSize: const Size(double.infinity, 55),
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'تحقق من الرمز',
                                  color: ColorManager.titleWhite,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                BlocBuilder<OtpValidationCubit, OtpValidationState>(
                  builder: (context, state) {
                    final isResending = state is OtpResendLoading;
                    return GestureDetector(
                      onTap: isResending
                          ? null
                          : () {
                              context.read<OtpValidationCubit>().resendOtp(
                                    phone: phone,
                                    flow: flow,
                                  );
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isResending
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorManager.deepGreen,
                                  ),
                                )
                              : Icon(Icons.refresh, color: ColorManager.deepGreen),
                          SizedBox(width: 8.w),
                          CustomText(
                            'إعادة إرسال الرمز',
                            color: ColorManager.deepGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}