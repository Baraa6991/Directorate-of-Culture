import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Auth/page/otpValidation.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/login_cubit.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/otp_validation_cubit.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(repository: ApiRepository()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginOtpSent) {
                AppSnackBar.show(context, state.message);
                final phone = context.read<LoginCubit>().phoneNumber;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Otpvalidation(
                      phone: phone,
                      flow: OtpFlowType.login, // ⬅️ تدفّق تسجيل الدخول
                    ),
                  ),
                );
              } else if (state is LoginError) {
                AppSnackBar.show(context, state.message, success: false);
              }
            },
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Enter your phone number to access cultural experiences.",
                    fontSize: 16,
                    color: ColorManager.black,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      "Phone Number",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      hintText: '09xxxxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    initialCountryCode: 'SY',
                    onChanged: (phone) {
                      context
                          .read<LoginCubit>()
                          .updatePhoneNumber(phone.completeNumber);
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<LoginCubit>().sendOtp();
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
                                "Send Code",
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
              );
            },
          ),
        ),
      ),
    );
  }
}