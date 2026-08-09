import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/Helper/cach_helper.dart';
import 'package:directorateofculture/presentation/pages/Auth/page/edit_profile_screen.dart';
import 'package:directorateofculture/presentation/pages/Auth/page/personal_info.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/profile_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/page/static_text_screen.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(repository: AuthRepository())..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomText('تسجيل الخروج'),
        content: const CustomText('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const CustomText('تراجع', color: ColorManager.gray),
          ),
          TextButton(
            onPressed: () async {
              await CacheHelper.removeAllData();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const PersonalInfo()),
                  (route) => false,
                );
              }
            },
            child: const CustomText('نعم، تسجيل الخروج', color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: CustomText(
          'الإعدادات',
          color: ColorManager.deepGreen,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(state.message, color: ColorManager.gray, fontSize: 13.sp),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () => context.read<ProfileCubit>().load(),
                    child: const CustomText('إعادة المحاولة', color: ColorManager.deepGreen),
                  ),
                ],
              ),
            );
          }

          final profile = (state as ProfileLoaded).profile;

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // ─── معلومات المستخدم ───
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44.r,
                      backgroundColor: ColorManager.lightGray.withOpacity(0.3),
                      backgroundImage: profile.avatarUrl != null
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? Icon(Icons.person, size: 40.sp, color: ColorManager.gray)
                          : null,
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      profile.name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      profile.phone,
                      fontSize: 12.sp,
                      color: ColorManager.gray,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // ─── الفعاليات المكتملة + النقاط ───
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      icon: Icons.event_available_outlined,
                      value: '${profile.completedEventsCount}',
                      label: 'فعالية مكتملة',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    // 🔶 عدد النقاط قيمة ثابتة مؤقتة حالياً بانتظار بناء نظام
                    // نقاط حقيقي بالباك اند لاحقاً.
                    child: _StatBox(
                      icon: Icons.stars_outlined,
                      value: '120',
                      label: 'نقطة',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              _SectionTitle('معلوماتي'),
              _SettingsTile(
                icon: Icons.edit_outlined,
                label: 'تعديل البروفايل',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileCubit>(),
                      child: const EditProfileScreen(),
                    ),
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.badge_outlined,
                label: 'بطاقة العضوية',
                onTap: null, // عرض فقط بدون أي تنقّل حالياً
              ),

              SizedBox(height: 20.h),
              _SectionTitle('حول التطبيق'),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: 'شروط الاستخدام',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StaticTextScreen(title: 'شروط الاستخدام'),
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'سياسة الخصوصية',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StaticTextScreen(title: 'سياسة الخصوصية'),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              _SettingsTile(
                icon: Icons.logout,
                label: 'تسجيل الخروج',
                labelColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _logout(context),
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatBox({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: ColorManager.titleWhite,
      radius: 16.r,
      paddingAll: 14,
      child: Column(
        children: [
          Icon(icon, color: ColorManager.deepGreen, size: 22.sp),
          SizedBox(height: 6.h),
          CustomText(value, fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorManager.black),
          SizedBox(height: 2.h),
          CustomText(label, fontSize: 11.sp, color: ColorManager.gray),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
      child: CustomText(
        title,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: ColorManager.gray,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: CustomContainer(
        color: ColorManager.titleWhite,
        radius: 14.r,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(icon, size: 20.sp, color: iconColor ?? ColorManager.deepGreen),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomText(
                    label,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? ColorManager.black,
                  ),
                ),
                if (onTap != null)
                  Icon(Icons.arrow_forward_ios, size: 14.sp, color: ColorManager.lightGray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}