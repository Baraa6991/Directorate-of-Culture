import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة عامة لعرض نص ثابت (شروط الاستخدام / سياسة الخصوصية).
/// ⚠️ النص أدناه نائب (placeholder) فقط — استبدله بالنص القانوني الفعلي
/// لمديرية الثقافة قبل النشر النهائي للتطبيق.
class StaticTextScreen extends StatelessWidget {
  final String title;
  const StaticTextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.black),
        title: CustomText(
          title,
          color: ColorManager.deepGreen,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: CustomText(
          'سيتم إضافة نص $title الرسمي هنا قريباً.\n\n'
          'هذا نص مؤقت (Placeholder) يوضّح مكان عرض المحتوى القانوني '
          'الفعلي لمديرية الثقافة، ويجب استبداله بالنص الرسمي المعتمد '
          'قبل إطلاق التطبيق للمستخدمين.',
          fontSize: 13.sp,
          color: ColorManager.black,
        ),
      ),
    );
  }
}