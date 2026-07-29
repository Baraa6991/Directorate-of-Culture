import 'package:directorateofculture/presentation/pages/Center%20Details/page/center_details.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/confirm_booking_screen.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/hall_details.dart';
import 'package:directorateofculture/presentation/pages/Home/page/CulturalSitesScreen.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/pages/Main/page/main_shell.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/page/volunteer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Directorate Of Culture',
          home: const MainShell(),
        );
      },
    );
  }
}
