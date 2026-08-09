import 'package:directorateofculture/presentation/pages/Auth/page/login.dart';
import 'package:directorateofculture/presentation/pages/Auth/page/otpValidation.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_cubit.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_state.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/register_cubit.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textfield.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PersonalInfoCubit()),
        BlocProvider(
          create: (context) => RegisterCubit(repository: AuthRepository()),
        ),
      ],
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView();

  void _onNextPressed(BuildContext context) {
    final personalInfoCubit = context.read<PersonalInfoCubit>();
    final personalInfoState = personalInfoCubit.state;

    context.read<RegisterCubit>().register(
      name: personalInfoCubit.fullName,
      phone: personalInfoCubit.phoneNumber,
      birthdate: personalInfoState.selectedBirthdate,
      gender: personalInfoState.selectedGender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalInfoCubit = context.read<PersonalInfoCubit>();

    return Scaffold(
      backgroundColor: ColorManager.darkForestGreen,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -24,
              right: -12,
              child: Container(
                width: 190.w,
                height: 190.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.deepGreen,
                ),
              ),
            ),
            Positioned(
              top: 18.h,
              left: 18.w,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.deepGreen,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 210.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: ColorManager.deepGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: ColorManager.titleWhite,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomText(
                          'نحتاج بعض المعلومات عنك!',
                          color: ColorManager.titleWhite,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.titleWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34.r),
                        topRight: Radius.circular(34.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black,
                          blurRadius: 24,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'الاسم الأول',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            controller: personalInfoCubit.firstNameController,
                            cursorColor: ColorManager.deepGreen,
                            hint: 'مثال: أحمد',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'اسم العائلة',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            controller: personalInfoCubit.lastNameController,
                            cursorColor: ColorManager.deepGreen,
                            hint: 'مثال: منصور',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'تاريخ الميلاد',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                            builder: (context, state) {
                              if (state.selectedBirthdate != null) {
                                personalInfoCubit.birthdateController.text =
                                    DateFormat(
                                      'dd / MM / yyyy',
                                    ).format(state.selectedBirthdate!);
                              }
                              return CustomTextfield(
                                controller:
                                    personalInfoCubit.birthdateController,
                                readOnly: true,
                                onTap: () {
                                  picker.DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900),
                                    maxTime: DateTime.now(),
                                    currentTime:
                                        state.selectedBirthdate ??
                                        DateTime.now(),
                                    theme: picker.DatePickerTheme(
                                      headerColor: ColorManager.titleWhite,
                                      backgroundColor: ColorManager.titleWhite,
                                      itemStyle: TextStyle(
                                        color: ColorManager.darkForestGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                      doneStyle: TextStyle(
                                        color: ColorManager.deepGreen,
                                        fontSize: 16.sp,
                                      ),
                                      cancelStyle: TextStyle(
                                        color: ColorManager.darkForestGreen,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    onConfirm: (date) {
                                      context
                                          .read<PersonalInfoCubit>()
                                          .selectBirthdate(date);
                                    },
                                    locale: picker.LocaleType.en,
                                  );
                                },
                                cursorColor: ColorManager.deepGreen,
                                hint: 'يوم / شهر / سنة',
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  color: ColorManager.deepGreen,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                focusColor: ColorManager.deepGreen,
                              );
                            },
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'رقم الهاتف',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 10.h),
                          IntlPhoneField(
                            decoration: InputDecoration(
                              hintText: '09xxxxxxxx',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            initialCountryCode: 'SY',
                            onChanged: (phone) {
                              personalInfoCubit.updatePhoneNumber(
                                phone.completeNumber,
                              );
                            },
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'الجنس',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 10.h),
                          BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<PersonalInfoCubit>()
                                            .selectGender('Male');
                                      },
                                      child: Container(
                                        height: 108.h,
                                        decoration: BoxDecoration(
                                          color: state.selectedGender == 'Male'
                                              ? ColorManager.lightGreen
                                                    .withOpacity(0.25)
                                              : ColorManager.titleWhite,
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          border: Border.all(
                                            color:
                                                state.selectedGender == 'Male'
                                                ? ColorManager.deepGreen
                                                : ColorManager.subtitleGreen,
                                            width:
                                                state.selectedGender == 'Male'
                                                ? 2
                                                : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.black
                                                  .withOpacity(0.03),
                                              blurRadius: 18,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.man_rounded,
                                              size: 44.sp,
                                              color: ColorManager.deepGreen,
                                            ),
                                            SizedBox(height: 8.h),
                                            CustomText(
                                              'ذكر',
                                              color:
                                                  ColorManager.darkForestGreen,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<PersonalInfoCubit>()
                                            .selectGender('Female');
                                      },
                                      child: Container(
                                        height: 108.h,
                                        decoration: BoxDecoration(
                                          color:
                                              state.selectedGender == 'Female'
                                              ? ColorManager.lightGreen
                                                    .withOpacity(0.25)
                                              : ColorManager.titleWhite,
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          border: Border.all(
                                            color:
                                                state.selectedGender == 'Female'
                                                ? ColorManager.deepGreen
                                                : ColorManager.subtitleGreen,
                                            width:
                                                state.selectedGender == 'Female'
                                                ? 2
                                                : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.black
                                                  .withOpacity(0.03),
                                              blurRadius: 18,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.woman_rounded,
                                              size: 44.sp,
                                              color: ColorManager.deepGreen,
                                            ),
                                            SizedBox(height: 8.h),
                                            CustomText(
                                              'أنثى',
                                              color:
                                                  ColorManager.darkForestGreen,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 28.h),
                          BlocConsumer<RegisterCubit, RegisterState>(
                            listener: (context, state) {
                              if (state is RegisterSuccess) {
                                AppSnackBar.show(context, state.message);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Otpvalidation(
                                      phone: personalInfoCubit.phoneNumber,
                                    ),
                                  ),
                                );
                              } else if (state is RegisterError) {
                                AppSnackBar.show(
                                  context,
                                  state.message,
                                  success: false,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is RegisterLoading;
                              return CustomElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _onNextPressed(context),
                                backgroundColor: ColorManager.deepGreen,
                                foregroundColor: ColorManager.titleWhite,
                                radius: 28.r,
                                fixedSize: const Size(double.infinity, 58),
                                child: isLoading
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            'التالي',
                                            color: ColorManager.titleWhite,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(width: 10.w),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: 20.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                "Already have an account?",
                                color: ColorManager.darkForestGreen,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),

                              SizedBox(width: 5.w),

                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const Login(), 
                                    ),
                                  );
                                },
                                child: CustomText(
                                  "Login",
                                  color: ColorManager.deepGreen,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
