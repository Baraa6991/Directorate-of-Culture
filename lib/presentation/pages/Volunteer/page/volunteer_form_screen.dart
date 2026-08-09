import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/checkbox.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/section_card.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_cubit.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_state.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/page/volunteer_success_screen.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VolunteerFormScreen extends StatelessWidget {
  const VolunteerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VolunteerFormCubit(),
      child: const _VolunteerFormView(),
    );
  }
}

// ====================== Label بنجمة حمراء للحقول الإجبارية ======================
class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const _FieldLabel(this.text, {this.required = true});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: ColorManager.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.normal,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

class _VolunteerFormView extends StatelessWidget {
  const _VolunteerFormView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.titleWhite,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          'طلب تطوع - دمشق',
          color: ColorManager.deepGreen,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: ColorManager.black),
        ),
      ),
      // ====================== ربط السناك بار + العودة للهوم ======================
      body: SafeArea(
        child: BlocListener<VolunteerFormCubit, VolunteerFormState>(
          listener: (context, state) {
            if (state.isSuccess && state.successMessage != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => VolunteerSuccessScreen(
                    message: state.successMessage!,
                  ),
                ),
              );
            } else if (state.errorMessage != null) {
              AppSnackBar.show(context, state.errorMessage!, success: false);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بانر علوي
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    children: [
                      Container(
                        height: 140.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorManager.darkForestGreen,
                              ColorManager.deepGreen,
                            ],
                          ),
                        ),
                        child: Image.asset(
                          AssetsManager.onboarding1Discover,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        bottom: 14.h,
                        right: 16.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'كن جزءًا من الحراك الثقافي',
                              color: ColorManager.titleWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              'ساعدنا في إنجاح فعاليات مديرية الثقافة',
                              color: ColorManager.subtitleGreen,
                              fontSize: 12.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ───────────── المعلومات الشخصية ─────────────
                SectionCard(
                  icon: Icons.person_outline,
                  title: 'المعلومات الشخصية',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('الاسم'),
                                    SizedBox(height: 6.h),
                                    CustomTextfield(
                                      hint: 'مثال: أحمد',
                                      hintColor: ColorManager.lightGray,
                                      filled: true,
                                      fillColor: ColorManager.lightBackground,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusColor: ColorManager.deepGreen,
                                      onChanged: (value) {
                                        context
                                            .read<VolunteerFormCubit>()
                                            .updateFirstName(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('الكنية'),
                                    SizedBox(height: 6.h),
                                    CustomTextfield(
                                      hint: 'مثال: الحسن',
                                      hintColor: ColorManager.lightGray,
                                      filled: true,
                                      fillColor: ColorManager.lightBackground,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusColor: ColorManager.deepGreen,
                                      onChanged: (value) {
                                        context
                                            .read<VolunteerFormCubit>()
                                            .updateLastName(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          const _FieldLabel('البريد الإلكتروني'),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: 'name@example.com',
                            hintColor: ColorManager.lightGray,
                            keyboardType: TextInputType.emailAddress,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updateEmail(value);
                            },
                          ),
                          SizedBox(height: 14.h),
                          const _FieldLabel('رقم الهاتف (واتساب)'),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: '09xx xxx xxx',
                            hintColor: ColorManager.lightGray,
                            keyboardType: TextInputType.phone,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: ColorManager.gray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updatePhone(value);
                            },
                          ),
                          SizedBox(height: 14.h),
                          const _FieldLabel('تاريخ الميلاد'),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: 'يوم-شهر-سنة',
                            hintColor: ColorManager.lightGray,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updateBirthPlace(value);
                            },
                          ),
                          SizedBox(height: 14.h),
                          const _FieldLabel('مكان الإقامة'),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: 'مثال: دمشق',
                            hintColor: ColorManager.lightGray,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updateResidence(value);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── التعليم ─────────────
                SectionCard(
                  icon: Icons.school_outlined,
                  title: 'التعليم',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('المستوى التعليمي'),
                          SizedBox(height: 6.h),
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: ColorManager.lightBackground,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.educationLevel,
                                isExpanded: true,
                                hint: CustomText(
                                  'اختر المستوى',
                                  color: ColorManager.lightGray,
                                  fontSize: 13.sp,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: ColorManager.gray,
                                ),
                                items: [
                                  'ثانوي',
                                  'دبلوم',
                                  'إدارة الأعمال',
                                  'بكالوريوس',
                                  'ماجستير',
                                  'دكتوراه',
                                ].map((level) {
                                  return DropdownMenuItem(
                                    value: level,
                                    child: CustomText(
                                      level,
                                      color: ColorManager.black,
                                      fontSize: 13.sp,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<VolunteerFormCubit>()
                                        .updateEducationLevel(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── الخبرة السابقة ─────────────
                SectionCard(
                  icon: Icons.headset_mic_outlined,
                  title: 'الخبرة السابقة',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('هل تطوعت سابقاً؟'),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: state.hasPreviousExperience,
                                    activeColor: ColorManager.deepGreen,
                                    onChanged: (value) {
                                      context
                                          .read<VolunteerFormCubit>()
                                          .updateHasPreviousExperience(true);
                                    },
                                  ),
                                  CustomText(
                                    'نعم',
                                    color: ColorManager.black,
                                    fontSize: 13.sp,
                                  ),
                                ],
                              ),
                              SizedBox(width: 16.w),
                              Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: state.hasPreviousExperience,
                                    activeColor: ColorManager.deepGreen,
                                    onChanged: (value) {
                                      context
                                          .read<VolunteerFormCubit>()
                                          .updateHasPreviousExperience(false);
                                    },
                                  ),
                                  CustomText(
                                    'لا',
                                    color: ColorManager.black,
                                    fontSize: 13.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          const _FieldLabel(
                              'لماذا ترغب بالتطوع مع مديرية الثقافية؟'),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: 'اكتب هنا...',
                            hintColor: ColorManager.lightGray,
                            maxLines: 3,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updateVolunteerMotivation(value);
                            },
                          ),
                          SizedBox(height: 14.h),
                          const _FieldLabel('الخبرات السابقة',
                              required: false),
                          SizedBox(height: 6.h),
                          CustomTextfield(
                            hint: 'اذكر تجاربك التطوعية أو الخبرة المشابهة...',
                            hintColor: ColorManager.lightGray,
                            maxLines: 3,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: (value) {
                              context
                                  .read<VolunteerFormCubit>()
                                  .updatePreviousExperience(value);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── مجالات التطوع ─────────────
                SectionCard(
                  icon: Icons.volunteer_activism_outlined,
                  title: 'مجالات التطوع *',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      final fields = [
                        'إعلامي (تصميم - تصوير- مونتاج)',
                        'المشاركة في الأنشطة',
                        'المشاركة في تنسيق الفعاليات',
                        'تقديم التدريب للأطفال',
                        'المشاركة في إقامة الورشات الفنية',
                        'العلاقات العامة',
                        'أخرى',
                      ];
                      return Column(
                        children: [
                          ...fields.map((field) {
                            final isChecked = state.selectedVolunteerFields
                                .contains(field);
                            return CheckboxRow(
                              label: field,
                              checked: isChecked,
                              onTap: () {
                                context
                                    .read<VolunteerFormCubit>()
                                    .toggleVolunteerField(field);
                              },
                            );
                          }),
                          if (state.selectedVolunteerFields
                              .contains('أخرى')) ...[
                            SizedBox(height: 12.h),
                            const _FieldLabel('يرجى توضيح مجال التطوع الآخر'),
                            SizedBox(height: 6.h),
                            CustomTextfield(
                              hint: 'اكتب المجال الآخر...',
                              hintColor: ColorManager.lightGray,
                              filled: true,
                              fillColor: ColorManager.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusColor: ColorManager.deepGreen,
                              onChanged: (value) {
                                context
                                    .read<VolunteerFormCubit>()
                                    .updateOtherVolunteerFieldDetails(value);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── المعدات والأدوات ─────────────
                SectionCard(
                  icon: Icons.handyman_outlined,
                  title: 'المعدات والأدوات *',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      final tools = [
                        'كاميرا',
                        'لابتوب',
                        'لا أملك معدات',
                        'أخرى'
                      ];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('هل تمتلك أدوات أو معدات خاصة؟'),
                          SizedBox(height: 6.h),
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: tools.map((tool) {
                              final isChecked =
                                  state.selectedTools.contains(tool);
                              return CheckboxRow(
                                label: tool,
                                checked: isChecked,
                                compact: true,
                                onTap: () {
                                  context
                                      .read<VolunteerFormCubit>()
                                      .toggleTool(tool);
                                },
                              );
                            }).toList(),
                          ),
                          if (state.selectedTools.contains('أخرى')) ...[
                            SizedBox(height: 12.h),
                            const _FieldLabel(
                                'يرجى توضيح المعدات أو الأدوات الأخرى'),
                            SizedBox(height: 6.h),
                            CustomTextfield(
                              hint: 'اكتب المعدات أو الأدوات الأخرى...',
                              hintColor: ColorManager.lightGray,
                              filled: true,
                              fillColor: ColorManager.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusColor: ColorManager.deepGreen,
                              onChanged: (value) {
                                context
                                    .read<VolunteerFormCubit>()
                                    .updateOtherToolDetails(value);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── المراكز المفضلة ─────────────
                SectionCard(
                  icon: Icons.location_city_outlined,
                  title: 'المراكز المفضلة *',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      return Column(
                        children: VolunteerFormCubit.centersMap.entries
                            .map((entry) {
                          final isChecked =
                              state.selectedCenterIds.contains(entry.key);
                          return CheckboxRow(
                            label: entry.value,
                            checked: isChecked,
                            onTap: () {
                              context
                                  .read<VolunteerFormCubit>()
                                  .toggleCenter(entry.key);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── التوقيتات المقترحة ─────────────
                SectionCard(
                  icon: Icons.access_time,
                  title: 'الأوقات المتاحة *',
                  child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                    builder: (context, state) {
                      final timings = [
                        'في أي وقت',
                        'الجمعة والسبت',
                        'من الأحد إلى الخميس صباحاً',
                        'من الأحد إلى الخميس مساءً',
                        'أونلاين',
                        'أخرى',
                      ];
                      return Column(
                        children: [
                          ...timings.map((timing) {
                            final isChecked =
                                state.selectedTimings.contains(timing);
                            return CheckboxRow(
                              label: timing,
                              checked: isChecked,
                              onTap: () {
                                context
                                    .read<VolunteerFormCubit>()
                                    .toggleTiming(timing);
                              },
                            );
                          }),
                          if (state.selectedTimings.contains('أخرى')) ...[
                            SizedBox(height: 12.h),
                            const _FieldLabel('يرجى توضيح الوقت الآخر'),
                            SizedBox(height: 6.h),
                            CustomTextfield(
                              hint: 'اكتب الوقت الآخر...',
                              hintColor: ColorManager.lightGray,
                              filled: true,
                              fillColor: ColorManager.lightBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              focusColor: ColorManager.deepGreen,
                              onChanged: (value) {
                                context
                                    .read<VolunteerFormCubit>()
                                    .updateOtherTimingDetails(value);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // ───────────── معلومة أخرى ─────────────
                SectionCard(
                  icon: Icons.info_outline,
                  title: 'إضافة أخرى',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('هل عندك ملاحظات إضافية؟',
                          required: false),
                      SizedBox(height: 6.h),
                      CustomTextfield(
                        hint: 'أي معلومات تود إضافتها...',
                        hintColor: ColorManager.lightGray,
                        maxLines: 3,
                        filled: true,
                        fillColor: ColorManager.lightBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                        focusColor: ColorManager.deepGreen,
                        onChanged: (value) {
                          context
                              .read<VolunteerFormCubit>()
                              .updateAdditionalInfo(value);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ====================== زر الإرسال ======================
                BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              context.read<VolunteerFormCubit>().submit();
                            },
                      backgroundColor: ColorManager.deepGreen,
                      foregroundColor: ColorManager.titleWhite,
                      radius: 28.r,
                      fixedSize: const Size(double.infinity, 56),
                      child: state.isSubmitting
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
                                  'إرسال الطلب',
                                  color: ColorManager.titleWhite,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.send, size: 18.sp),
                              ],
                            ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}