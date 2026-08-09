import 'package:directorateofculture/presentation/pages/AI/assistant_screen.dart';
import 'package:directorateofculture/presentation/pages/AI/for_you_section.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/cultural_centers_screen.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/events_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/page/settings_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cubit/coming_activities_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cubit/finished_activities_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/page/finished_events_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cubit/home_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/page/CulturalSitesScreen.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Featured%20Events/featured_events_cart.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Past%20Events/past_events_cart.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBanner.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/QuickAccessItem/quick_access_item.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Volunteer%20Now%20Card/volunteer_now_card.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Libraries/cubit/books_list_cubit.dart';
import 'package:directorateofculture/presentation/pages/Libraries/page/books_list_screen.dart';
import 'package:directorateofculture/presentation/pages/Notification/widget/notification_bell.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:directorateofculture/repositories/library_repository.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Page/reservations_archive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = HomeRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(repository: repository)..loadHome(),
        ),
        BlocProvider(
          create: (context) =>
              ComingActivitiesCubit(repository: repository)..loadFirstPage(),
        ),
        BlocProvider(
          create: (context) =>
              FinishedActivitiesCubit(repository: repository)..loadFirstPage(),
        ),
      ],
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  /// يُعاد تحميل كل بيانات الرئيسية (الملف الشخصي/الإعلانات، الفعاليات
  /// القادمة، الفعاليات المنتهية) — يُستدعى بعد العودة من أي شاشة فرعية
  /// (الإشعارات، الإعدادات، الفعاليات، المكتبة، المراكز، الخريطة، الأرشيف)
  /// حتى تبقى الرئيسية محدَّثة دائماً بأحدث البيانات دون حاجة لإعادة فتح
  /// التطبيق يدوياً.
  void _refreshHome() {
    if (!mounted) return;
    context.read<HomeCubit>().loadHome();
    context.read<ComingActivitiesCubit>().loadFirstPage();
    context.read<FinishedActivitiesCubit>().loadFirstPage();
  }

  /// يفتح شاشة فرعية عبر Navigator.push، وينتظر العودة منها ليُحدِّث
  /// بيانات الرئيسية تلقائياً فور الرجوع إليها.
  Future<void> _pushAndRefresh(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    _refreshHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),

              // ====================== Header (Avatar + Name) ======================
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    String userName = '...';
                    String? avatarUrl;

                    if (state is HomeLoaded) {
                      userName = state.userName;
                      avatarUrl = state.avatarUrl;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30.r,
                              backgroundImage:
                                  (avatarUrl != null && avatarUrl.isNotEmpty)
                                  ? NetworkImage(avatarUrl)
                                  : AssetImage(AssetsManager.logo)
                                        as ImageProvider,
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'مرحباً، $userName 👋',
                                  color: ColorManager.black,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  'عضو في مديرية الثقافة',
                                  color: ColorManager.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _pushAndRefresh(const SettingsScreen());
                              },
                              icon: Icon(Icons.settings_outlined,
                                  size: 28.sp, color: ColorManager.black),
                            ),
                            NotificationBell(onReturn: _refreshHome),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AssistantScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: ColorManager.lightBackground,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 36.h,
                          width: 36.w,
                          decoration: BoxDecoration(
                            color: ColorManager.deepGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: ColorManager.titleWhite,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        CustomText(
                          'اسأل المساعد الذكي',
                          color: ColorManager.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: ColorManager.gray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),

              // ====================== Ads Banner ======================
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoaded && state.ads.isNotEmpty) {
                      return AdBanner(ads: state.ads);
                    }
                    return SizedBox(height: 240.h);
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              SliverToBoxAdapter(child: ForYouSection()),
              SliverToBoxAdapter(
                child: QuickAccessGrid(
                  items: [
                    QuickAccessItem(
                      icon: Icons.account_balance_outlined,
                      label: 'المراكز',
                      onTap: () {
                        _pushAndRefresh(const CulturalCentersScreen());
                      },
                    ),
                    QuickAccessItem(
                      icon: Icons.event_outlined,
                      label: 'الفعاليات',
                      onTap: () {
                        _pushAndRefresh(const ActivitiesScreen());
                      },
                    ),
                    QuickAccessItem(
                      icon: Icons.bookmark_outline,
                      label: 'المكتبة',
                      onTap: () {
                        _pushAndRefresh(
                          BlocProvider(
                            create: (context) => BooksListCubit(
                              LibraryRepository(),
                            ),
                            child: const BooksListScreen(),
                          ),
                        );
                      },
                    ),
                    QuickAccessItem(
                      icon: Icons.map_outlined,
                      label: 'الخريطة',
                      onTap: () {
                        _pushAndRefresh(const CulturalSitesScreen());
                      },
                    ),
                    QuickAccessItem(
                      icon: Icons.confirmation_number_outlined,
                      label: 'أرشيف حجوزاتي',
                      onTap: () {
                        _pushAndRefresh(const ReservationsArchiveScreen());
                      },
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),

              // ====================== Featured (Coming) Events Header ======================
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'الفعاليات المميزة',
                      color: ColorManager.deepGreen,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pushAndRefresh(const ActivitiesScreen());
                      },
                      child: CustomText(
                        'عرض الكل',
                        color: ColorManager.deepGreen,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14.h)),

              // ====================== Featured (Coming) Events List ======================
              SliverToBoxAdapter(
                child:
                    BlocBuilder<ComingActivitiesCubit, ComingActivitiesState>(
                      builder: (context, state) {
                        if (state.isLoading && state.activities.isEmpty) {
                          return SizedBox(
                            height: 340.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state.activities.isEmpty) {
                          return SizedBox(
                            height: 100.h,
                            child: Center(
                              child: CustomText(
                                'لا توجد فعاليات قادمة حالياً',
                                color: ColorManager.gray,
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 340.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.activities.length,
                            itemBuilder: (context, index) {
                              return FeaturedEventsCart(
                                activity: state.activities[index],
                              );
                            },
                          ),
                        );
                      },
                    ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),

              // ====================== Past (Finished) Events Header ======================
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'الفعاليات القديمة',
                      color: ColorManager.deepGreen,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pushAndRefresh(const FinishedEventsScreen());
                      },
                      child: CustomText(
                        'عرض الكل',
                        color: ColorManager.deepGreen,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14.h)),

              // ====================== Past (Finished) Events List ======================
              BlocBuilder<FinishedActivitiesCubit, FinishedActivitiesState>(
                builder: (context, state) {
                  if (state.isLoading && state.activities.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (state.activities.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CustomText(
                            'لا توجد فعاليات سابقة',
                            color: ColorManager.gray,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: state.activities.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      return PastEventsCart(activity: state.activities[index]);
                    },
                  );
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              const SliverToBoxAdapter(child: VolunteerNowCard()),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          ),
        ),
      ),
    );
  }
}