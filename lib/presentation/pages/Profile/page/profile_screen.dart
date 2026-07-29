import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Profile/page/edit_profile_screen.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/logout_confirmation_dialog.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/profile_membership_card.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/profile_menu_tile.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/profile_stat_tile.dart';
import 'package:directorateofculture/presentation/pages/Profile/widget/user_profile_model.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _profile = UserProfileModel(
    name: 'أحمد',
    membershipTier: 'عضو ذهبي',
    membershipTitle: 'عضوية المركز الثقافي',
    memberId: 'CH-8829-2024',
    joinedDate: 'مارس 2021',
    expiresDate: 'ديسمبر 2024',
    eventsCount: 24,
    hoursVolunteered: 12.5,
    points: 0,
  );

  void _showComingSoon(BuildContext context) {
    AppSnackBar.show(context, 'قريباً');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.lightBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
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
                            radius: 44.r,
                            backgroundColor: ColorManager.lightGray.withOpacity(
                              0.3,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 44.sp,
                              color: ColorManager.gray,
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: ColorManager.premiumBadge,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.titleWhite,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                size: 14.sp,
                                color: ColorManager.goldMemberText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        _profile.name,
                        color: ColorManager.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.premiumBadge,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          _profile.membershipTier,
                          color: ColorManager.goldMemberText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                ProfileMembershipCard(profile: _profile),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ProfileStatTile(
                        icon: Icons.event_available_outlined,
                        value: '${_profile.eventsCount}',
                        label: 'الفعاليات',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ProfileStatTile(
                        icon: Icons.volunteer_activism_outlined,
                        value: '${_profile.hoursVolunteered}',
                        label: 'ساعات',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ProfileStatTile(
                        icon: Icons.stars_outlined,
                        value: '${_profile.points}',
                        label: 'النقاط',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                CustomText(
                  'المعلومات الشخصية',
                  color: ColorManager.gray,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: ColorManager.titleWhite,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.person_outline,
                        title: 'تعديل الملف الشخصي',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: ColorManager.lightBackground),
                      ProfileMenuTile(
                        icon: Icons.badge_outlined,
                        title: 'بطاقة الهوية الرقمية',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomText(
                  'التفضيلات',
                  color: ColorManager.gray,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: ColorManager.titleWhite,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.notifications_none,
                        title: 'الإشعارات',
                        onTap: () => _showComingSoon(context),
                      ),
                      Divider(height: 1, color: ColorManager.lightBackground),
                      ProfileMenuTile(
                        icon: Icons.language,
                        title: 'اللغة',
                        trailingText: 'العربية',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomText(
                  'أمان الحساب',
                  color: ColorManager.gray,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: ColorManager.titleWhite,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.shield_outlined,
                        title: 'الخصوصية',
                        onTap: () => _showComingSoon(context),
                      ),
                      Divider(height: 1, color: ColorManager.lightBackground),
                      ProfileMenuTile(
                        icon: Icons.help_outline,
                        title: 'الدعم',
                        onTap: () => _showComingSoon(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                CustomElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const LogoutConfirmationDialog(),
                  ),
                  backgroundColor: ColorManager.rejectedRed.withOpacity(0.08),
                  foregroundColor: ColorManager.rejectedRed,
                  radius: 16,
                  paddingVertical: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 18.sp,
                        color: ColorManager.rejectedRed,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: CustomText(
                          'تسجيل الخروج',
                          color: ColorManager.rejectedRed,
                          fontSize: 14,
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
