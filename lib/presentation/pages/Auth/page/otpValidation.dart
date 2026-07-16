import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/otp_validation_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      create: (context) => OtpValidationCubit(repository: ApiRepository()),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 100),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                const SizedBox(height: 150),
                CustomText(
                  'Verify Your Number',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  textAlign: TextAlign.center,
                  color: ColorManager.black,
                ),
                const SizedBox(height: 15),
                CustomText(
                  'Enter the 4-digit verification code \nsent to your phone.',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  color: ColorManager.black,
                ),
                const SizedBox(height: 40),
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.deepGreen, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onCompleted: (pin) {
                    currentCode.value = pin;
                  },
                ),
                const SizedBox(height: 40),
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
                      radius: 30,
                      fixedSize: const Size(double.infinity, 55),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  "Check Code",
                                  color: ColorManager.titleWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),
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
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorManager.deepGreen,
                                  ),
                                )
                              : Icon(Icons.refresh, color: ColorManager.deepGreen),
                          const SizedBox(width: 8),
                          CustomText(
                            "Resend Code",
                            color: ColorManager.deepGreen,
                            fontSize: 14,
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