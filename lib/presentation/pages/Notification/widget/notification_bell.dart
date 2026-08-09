import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Notification/page/notifications_screen.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// جرس الإشعارات بالشاشة الرئيسية — يعرض رقماً أحمر بعدد الإشعارات غير
/// المقروءة، ويختفي تلقائياً بعد دخول شاشة الإشعارات والخروج منها (لأن
/// الشاشة تُعلِّم كل الإشعارات كمقروءة عند مغادرتها).
class NotificationBell extends StatefulWidget {
  /// يُستدعى بعد العودة من شاشة الإشعارات — يسمح لمن يستخدم هذا الـWidget
  /// (كالشاشة الرئيسية) بتحديث بياناته الخاصة أيضاً عند تلك اللحظة.
  final VoidCallback? onReturn;

  const NotificationBell({super.key, this.onReturn});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final MiscRepository _repository = MiscRepository();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshCount();
  }

  Future<void> _refreshCount() async {
    try {
      final count = await _repository.getUnreadNotificationsCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {
      // فشل صامت هنا مقصود: عدم القدرة على جلب العدد لا يجب أن يعطّل الرئيسية
    }
  }

  Future<void> _openNotifications() async {
    // ننتظر العودة من الشاشة (تُعلِّم كل شيء كمقروء عند مغادرتها)، ثم
    // نُحدّث العدد فوراً فيختفي الرقم الأحمر بشكل احترافي بدون أي تأخير.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
    _refreshCount();
    widget.onReturn?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: _openNotifications,
          icon: Icon(Icons.notifications_outlined, size: 30.sp, color: ColorManager.black),
        ),
        if (_unreadCount > 0)
          Positioned(
            top: 6.h,
            right: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: ColorManager.lightBackground, width: 1.5),
              ),
              alignment: Alignment.center,
              child: CustomText(
                _unreadCount > 99 ? '99+' : '$_unreadCount',
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}