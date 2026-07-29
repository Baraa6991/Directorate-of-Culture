import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Archive/page/archive_screen.dart';
import 'package:directorateofculture/presentation/pages/Events/page/events_list_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/pages/Main/widget/main_bottom_nav_bar.dart';
import 'package:directorateofculture/presentation/pages/Main/widget/main_navigation_cubit.dart';
import 'package:directorateofculture/presentation/pages/Main/widget/main_navigation_state.dart';
import 'package:directorateofculture/presentation/pages/Main/widget/placeholder_tab_screen.dart';
import 'package:directorateofculture/presentation/pages/Profile/page/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _tabs = [
    HomePageScreen(),
    EventsListScreen(),
    ArchiveScreen(),
    PlaceholderTabScreen(icon: Icons.favorite_border, title: 'Favorites'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainNavigationCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<MainNavigationCubit>();
          return BlocBuilder<MainNavigationCubit, MainNavigationState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: ColorManager.titleWhite,
                body: IndexedStack(index: state.selectedIndex, children: _tabs),
                bottomNavigationBar: MainBottomNavBar(
                  selectedIndex: state.selectedIndex,
                  onTap: cubit.selectTab,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
