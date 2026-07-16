import 'package:directorateofculture/presentation/pages/Volunteer/widget/checkbox.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/section_card.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_cubit.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_state.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: ColorManager.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بانر علوي
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      height: 140,
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
                      left: 16,
                      bottom: 14,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'كن جزءًا من الحراك الثقافي',
                            color: ColorManager.titleWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            'ساعدنا في إنجاح فعاليات مديرية الثقافة',
                            color: ColorManager.subtitleGreen,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'الاسم',
                                    color: ColorManager.black,
                                    fontSize: 13,
                                  ),
                                  const SizedBox(height: 6),
                                  CustomTextfield(
                                    hint: 'مثال: أحمد',
                                    hintColor: ColorManager.lightGray,
                                    filled: true,
                                    fillColor: ColorManager.lightBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'الكنية',
                                    color: ColorManager.black,
                                    fontSize: 13,
                                  ),
                                  const SizedBox(height: 6),
                                  CustomTextfield(
                                    hint: 'مثال: الحسن',
                                    hintColor: ColorManager.lightGray,
                                    filled: true,
                                    fillColor: ColorManager.lightBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
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
                        const SizedBox(height: 14),
                        CustomText(
                          'البريد الإلكتروني',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        CustomTextfield(
                          hint: 'name@example.com',
                          hintColor: ColorManager.lightGray,
                          keyboardType: TextInputType.emailAddress,
                          filled: true,
                          fillColor: ColorManager.lightBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: ColorManager.deepGreen,
                          onChanged: (value) {
                            context.read<VolunteerFormCubit>().updateEmail(
                              value,
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomText(
                          'رقم الهاتف (واتساب)',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
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
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: ColorManager.deepGreen,
                          onChanged: (value) {
                            context.read<VolunteerFormCubit>().updatePhone(
                              value,
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomText(
                          'تاريخ الميلاد',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        CustomTextfield(
                          hint: 'dd / MM / yyyy',
                          hintColor: ColorManager.lightGray,
                          filled: true,
                          fillColor: ColorManager.lightBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: ColorManager.deepGreen,
                          onChanged: (value) {
                            context.read<VolunteerFormCubit>().updateBirthPlace(
                              value,
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomText(
                          'مكان الإقامة',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        CustomTextfield(
                          hint: 'مثال: دمشق',
                          hintColor: ColorManager.lightGray,
                          filled: true,
                          fillColor: ColorManager.lightBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: ColorManager.deepGreen,
                          onChanged: (value) {
                            context.read<VolunteerFormCubit>().updateResidence(
                              value,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ───────────── التعليم ─────────────
              SectionCard(
                icon: Icons.school_outlined,
                title: 'التعليم',
                child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'المستوى التعليمي',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: ColorManager.lightBackground,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.educationLevel,
                              isExpanded: true,
                              hint: CustomText(
                                'اختر المستوى',
                                color: ColorManager.lightGray,
                                fontSize: 13,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorManager.gray,
                              ),
                              items:
                                  [
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
                                        fontSize: 13,
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
              const SizedBox(height: 16),

              // ───────────── الخبرة السابقة ─────────────
              SectionCard(
                icon: Icons.headset_mic_outlined,
                title: 'الخبرة السابقة',
                child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'هل تطوعت سابقاً؟',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
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
                                  fontSize: 13,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
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
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'لماذا ترغب بالتطوع مع مديرية الثقافية؟',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        CustomTextfield(
                          hint: 'اكتب هنا...',
                          hintColor: ColorManager.lightGray,
                          maxLines: 3,
                          filled: true,
                          fillColor: ColorManager.lightBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusColor: ColorManager.deepGreen,
                          onChanged: (value) {
                            context
                                .read<VolunteerFormCubit>()
                                .updateVolunteerMotivation(value);
                          },
                        ),
                        const SizedBox(height: 14),
                        CustomText(
                          'الخبرات السابقة',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        CustomTextfield(
                          hint: 'اذكر تجاربك التطوعية أو الخبرة المشابهة...',
                          hintColor: ColorManager.lightGray,
                          maxLines: 3,
                          filled: true,
                          fillColor: ColorManager.lightBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
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
              const SizedBox(height: 16),

              // ───────────── مجالات التطوع ─────────────
              SectionCard(
                icon: Icons.volunteer_activism_outlined,
                title: 'مجالات التطوع',
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
                        if (state.selectedVolunteerFields.contains('أخرى')) ...[
                          const SizedBox(height: 12),
                          CustomText(
                            'يرجى توضيح مجال التطوع الآخر',
                            color: ColorManager.black,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 6),
                          CustomTextfield(
                            hint: 'اكتب المجال الآخر...',
                            hintColor: ColorManager.lightGray,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
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
              const SizedBox(height: 16),

              // ───────────── المعدات والأدوات ─────────────
              SectionCard(
                icon: Icons.handyman_outlined,
                title: 'المعدات والأدوات',
                child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                  builder: (context, state) {
                    final tools = ['كاميرا', 'لابتوب', 'لا أملك معدات', 'أخرى'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'هل تمتلك أدوات أو معدات خاصة؟',
                          color: ColorManager.black,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: tools.map((tool) {
                            final isChecked = state.selectedTools.contains(
                              tool,
                            );
                            return CheckboxRow(
                              label: tool,
                              checked: isChecked,
                              compact: true,
                              onTap: () {
                                context.read<VolunteerFormCubit>().toggleTool(
                                  tool,
                                );
                              },
                            );
                          }).toList(),
                        ),
                        if (state.selectedTools.contains('أخرى')) ...[
                          const SizedBox(height: 12),
                          CustomText(
                            'يرجى توضيح المعدات أو الأدوات الأخرى',
                            color: ColorManager.black,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 6),
                          CustomTextfield(
                            hint: 'اكتب المعدات أو الأدوات الأخرى...',
                            hintColor: ColorManager.lightGray,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
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
              const SizedBox(height: 16),

              // ───────────── المراكز المفضلة ─────────────
              SectionCard(
                icon: Icons.location_city_outlined,
                title: 'المراكز المفضلة',
                child: BlocBuilder<VolunteerFormCubit, VolunteerFormState>(
                  builder: (context, state) {
                    final centers = {
                      '1': 'التطوع مع فريق مديرية الثقافة',
                      '2': 'مركز برزة',
                      '3': 'مركز العدوي',
                      '4': 'مركز الميدان',
                      '5': 'مركز المزة',
                      '6': 'مركز أبو رمانة',
                      '7': 'مركز كفر سوسة',
                    };
                    return Column(
                      children: centers.entries.map((entry) {
                        final isChecked = state.selectedCenterIds.contains(
                          entry.key,
                        );
                        return CheckboxRow(
                          label: entry.value,
                          checked: isChecked,
                          onTap: () {
                            context.read<VolunteerFormCubit>().toggleCenter(
                              entry.key,
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ───────────── التوقيتات المقترحة ─────────────
              SectionCard(
                icon: Icons.access_time,
                title: 'الأوقات المتاحة',
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
                          final isChecked = state.selectedTimings.contains(
                            timing,
                          );
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
                          const SizedBox(height: 12),
                          CustomText(
                            'يرجى توضيح الوقت الآخر',
                            color: ColorManager.black,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 6),
                          CustomTextfield(
                            hint: 'اكتب الوقت الآخر...',
                            hintColor: ColorManager.lightGray,
                            filled: true,
                            fillColor: ColorManager.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
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
              const SizedBox(height: 16),

              // ───────────── معلومة أخرى ─────────────
              SectionCard(
                icon: Icons.info_outline,
                title: 'إضافة أخرى',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'هل عندك ملاحظات إضافية؟',
                      color: ColorManager.black,
                      fontSize: 13,
                    ),
                    const SizedBox(height: 6),
                    CustomTextfield(
                      hint: 'أي معلومات تود إضافتها...',
                      hintColor: ColorManager.lightGray,
                      maxLines: 3,
                      filled: true,
                      fillColor: ColorManager.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusColor: ColorManager.deepGreen,
                      onChanged: (value) {
                        context.read<VolunteerFormCubit>().updateAdditionalInfo(
                          value,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // زر الإرسال
              CustomElevatedButton(
                onPressed: () {
                  context.read<VolunteerFormCubit>().submit();
                },
                backgroundColor: ColorManager.deepGreen,
                foregroundColor: ColorManager.titleWhite,
                radius: 28,
                fixedSize: const Size(double.infinity, 56),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      'إرسال الطلب',
                      color: ColorManager.titleWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.send, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}






