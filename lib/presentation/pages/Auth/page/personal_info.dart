import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_cubit.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_state.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
    

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInfoCubit(),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatelessWidget {
  const _PersonalInfoView();

  @override
  Widget build(BuildContext context) {
    final birthdateController = TextEditingController();

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
              top: 18,
              left: 18,
              child: Container(
                width: 32,
                height: 32,
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
                          onTap: () {},
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
                          'We Need Some Info About You!',
                          color: ColorManager.titleWhite,
                          fontSize: 24,
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
                            'First Name',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            cursorColor: ColorManager.deepGreen,
                            hint: 'e.g. Ahmed',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'Last Name',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            cursorColor: ColorManager.deepGreen,
                            hint: 'e.g. Mansour',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 18.h),
                          CustomText(
                            'Birthdate',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                            builder: (context, state) {
                              if (state.selectedBirthdate != null) {
                                birthdateController.text = DateFormat(
                                  'dd / MM / yyyy',
                                ).format(state.selectedBirthdate!);
                              }
                              return CustomTextfield(
                                controller: birthdateController,
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
                                        fontSize: 18.sp,
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
                                hint: 'DD / MM / YYYY',
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
                            'Gender',
                            color: ColorManager.darkForestGreen,
                            fontSize: 14,
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
                                            width: state.selectedGender == 'Male'
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
                                              'Male',
                                              color:
                                                  ColorManager.darkForestGreen,
                                              fontSize: 15,
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
                                                state.selectedGender ==
                                                    'Female'
                                                ? ColorManager.deepGreen
                                                : ColorManager.subtitleGreen,
                                            width:
                                                state.selectedGender ==
                                                    'Female'
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
                                              'Female',
                                              color:
                                                  ColorManager.darkForestGreen,
                                              fontSize: 15,
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
                          CustomElevatedButton(
                            onPressed: () {},
                            backgroundColor: ColorManager.deepGreen,
                            foregroundColor: ColorManager.titleWhite,
                            radius: 28,
                            fixedSize: const Size(double.infinity, 58),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'Next',
                                  color: ColorManager.titleWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 10.w),
                                const Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
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