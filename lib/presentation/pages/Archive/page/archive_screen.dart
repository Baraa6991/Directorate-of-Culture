import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Archive/widget/archive_center_card.dart';
import 'package:directorateofculture/presentation/pages/Archive/widget/archive_cubit.dart';
import 'package:directorateofculture/presentation/pages/Archive/widget/archive_event_card.dart';
import 'package:directorateofculture/presentation/pages/Archive/widget/archive_state.dart';
import 'package:directorateofculture/presentation/pages/Archive/widget/archive_tab_toggle.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "حجوزاتي" (My Bookings / Archive) screen — MainShell's Bookings tab.
///
/// Lists the user's event and cultural-center reservations behind a
/// two-item tab toggle.
class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => ArchiveCubit(),
        child: Scaffold(
          backgroundColor: ColorManager.lightBackground,
          body: SafeArea(
            child: BlocBuilder<ArchiveCubit, ArchiveState>(
              builder: (context, state) {
                final cubit = context.read<ArchiveCubit>();
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                          'حجوزاتي',
                          color: ColorManager.darkForestGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ArchiveTabToggle(
                        selectedIndex: state.selectedTabIndex,
                        onChanged: cubit.selectTab,
                        labels: const ['الفعاليات', 'المراكز الثقافية'],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                        children: state.selectedTabIndex == 0
                            ? state.events
                                  .map(
                                    (event) => Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: ArchiveEventCard(event: event),
                                    ),
                                  )
                                  .toList()
                            : state.centers
                                  .map(
                                    (center) => Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: ArchiveCenterCard(center: center),
                                    ),
                                  )
                                  .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
