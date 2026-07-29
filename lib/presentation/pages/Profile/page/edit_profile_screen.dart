import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/edit_profile_cubit.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/edit_profile_state.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController(text: 'أحمد');
    final nicknameController = TextEditingController(text: 'المنصوري');
    final emailController = TextEditingController(
      text: 'ahmed.almansouri@example.com',
    );
    final phoneController = TextEditingController(text: '+971 50 123 4567');
    final birthdateController = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.titleWhite,
        appBar: AppBar(
          backgroundColor: ColorManager.titleWhite,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: ColorManager.darkForestGreen),
          ),
          title: CustomText(
            'تعديل الملف الشخصي',
            color: ColorManager.darkForestGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 46.r,
                            backgroundColor: ColorManager.lightBackground,
                            child: Icon(
                              Icons.person,
                              size: 46.sp,
                              color: ColorManager.gray,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: ColorManager.deepGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.titleWhite,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14.sp,
                                color: ColorManager.titleWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        'تغيير الصورة الشخصية',
                        color: ColorManager.gray,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'الكنية',
                            color: ColorManager.darkForestGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            controller: nicknameController,
                            cursorColor: ColorManager.deepGreen,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'الاسم الأول',
                            color: ColorManager.darkForestGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextfield(
                            controller: firstNameController,
                            cursorColor: ColorManager.deepGreen,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                CustomText(
                  'البريد الإلكتروني',
                  color: ColorManager.darkForestGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomTextfield(
                  controller: emailController,
                  readOnly: true,
                  enabled: false,
                  filled: true,
                  fillColor: ColorManager.lightBackground,
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: ColorManager.gray,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  focusColor: ColorManager.deepGreen,
                ),
                SizedBox(height: 18.h),
                CustomText(
                  'رقم الهاتف',
                  color: ColorManager.darkForestGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomTextfield(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  cursorColor: ColorManager.deepGreen,
                  filled: true,
                  fillColor: ColorManager.lightBackground,
                  suffixIcon: Icon(
                    Icons.phone_outlined,
                    color: ColorManager.gray,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  focusColor: ColorManager.deepGreen,
                ),
                SizedBox(height: 18.h),
                CustomText(
                  'تاريخ الميلاد',
                  color: ColorManager.darkForestGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    if (state.selectedBirthdate != null) {
                      birthdateController.text = intl.DateFormat(
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
                              state.selectedBirthdate ?? DateTime.now(),
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
                            context.read<EditProfileCubit>().selectBirthdate(
                              date,
                            );
                          },
                          locale: picker.LocaleType.en,
                        );
                      },
                      cursorColor: ColorManager.deepGreen,
                      filled: true,
                      fillColor: ColorManager.lightBackground,
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                      focusColor: ColorManager.deepGreen,
                    );
                  },
                ),
                SizedBox(height: 18.h),
                CustomText(
                  'الجنس',
                  color: ColorManager.darkForestGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 10.h),
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: _GenderTile(
                            label: 'أنثى',
                            selected: state.selectedGender == 'أنثى',
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .selectGender('أنثى'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _GenderTile(
                            label: 'ذكر',
                            selected: state.selectedGender == 'ذكر',
                            onTap: () => context
                                .read<EditProfileCubit>()
                                .selectGender('ذكر'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 28.h),
                CustomElevatedButton(
                  onPressed: () {
                    AppSnackBar.show(context, 'تم حفظ التعديلات');
                    Navigator.pop(context);
                  },
                  backgroundColor: ColorManager.deepGreen,
                  foregroundColor: ColorManager.titleWhite,
                  radius: 26,
                  fixedSize: Size(double.infinity, 54.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        size: 18.sp,
                        color: ColorManager.titleWhite,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: CustomText(
                          'حفظ التعديلات',
                          color: ColorManager.titleWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
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

class _GenderTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManager.titleWhite,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? ColorManager.deepGreen : ColorManager.lightGray,
            width: selected ? 2 : 1,
          ),
        ),
        child: CustomText(
          label,
          color: selected ? ColorManager.deepGreen : ColorManager.gray,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
