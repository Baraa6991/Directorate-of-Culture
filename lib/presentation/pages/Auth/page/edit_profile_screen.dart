import 'dart:io';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/profile_cubit.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// شاشة "تعديل الملف الشخصي" — الاسم، تاريخ الميلاد، الجنس، وصورة الملف
/// الشخصي (تُختار من معرض الجهاز مباشرة وتُرفع فوراً للباك اند).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  DateTime? _selectedDate;
  String _selectedGender = 'male';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    final profile = state is ProfileLoaded ? state.profile : null;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _selectedDate = profile?.dateOfBirth;
    _selectedGender = profile?.gender ?? 'male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null || !mounted) return;

    try {
      await context.read<ProfileCubit>().uploadAvatar(File(picked.path));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: CustomText('تم تحديث الصورة بنجاح', color: Colors.white)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: CustomText('يرجى تعبئة كل الحقول', color: Colors.white)),
      );
      return;
    }

    try {
      final success = await context.read<ProfileCubit>().updateProfile(
            name: _nameController.text.trim(),
            dateOfBirth: DateFormat('yyyy-MM-dd').format(_selectedDate!),
            gender: _selectedGender,
          );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: CustomText('تم حفظ التعديلات بنجاح', color: Colors.white)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.black),
        title: CustomText(
          'تعديل الملف الشخصي',
          color: ColorManager.deepGreen,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = state.profile;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // ─── الصورة الشخصية ───
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: ColorManager.lightGray.withOpacity(0.3),
                        backgroundImage: profile.avatarUrl != null
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        child: profile.avatarUrl == null
                            ? Icon(Icons.person, size: 44.sp, color: ColorManager.gray)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: GestureDetector(
                          onTap: state.isSaving ? null : _pickImage,
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: ColorManager.deepGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: ColorManager.titleWhite, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                CustomText(
                  'تغيير الصورة الشخصية',
                  fontSize: 12.sp,
                  color: ColorManager.gray,
                ),
                SizedBox(height: 28.h),

                // ─── الاسم ───
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText('الاسم', fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6.h),
                CustomTextfield(
                  controller: _nameController,
                  hint: 'اسمك الكامل',
                ),
                SizedBox(height: 18.h),

                // ─── تاريخ الميلاد ───
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText('تاريخ الميلاد', fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: CustomTextfield(
                      hint: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'يوم / شهر / سنة',
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : '',
                      ),
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),

                // ─── الجنس ───
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText('الجنس', fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: _GenderOption(
                        label: 'ذكر',
                        selected: _selectedGender == 'male',
                        onTap: () => setState(() => _selectedGender = 'male'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _GenderOption(
                        label: 'أنثى',
                        selected: _selectedGender == 'female',
                        onTap: () => setState(() => _selectedGender = 'female'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    backgroundColor: ColorManager.deepGreen,
                    radius: 12.r,
                    paddingVertical: 14,
                    onPressed: state.isSaving ? null : _save,
                    child: state.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : CustomText(
                            'حفظ التعديلات',
                            color: ColorManager.titleWhite,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? ColorManager.deepGreen.withOpacity(0.1) : ColorManager.titleWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? ColorManager.deepGreen : ColorManager.lightGray.withOpacity(0.4),
          ),
        ),
        alignment: Alignment.center,
        child: CustomText(
          label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: selected ? ColorManager.deepGreen : ColorManager.gray,
        ),
      ),
    );
  }
}