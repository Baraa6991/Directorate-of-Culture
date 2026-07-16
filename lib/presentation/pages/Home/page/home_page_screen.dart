import 'package:directorateofculture/presentation/pages/Home/page/CulturalSitesScreen.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Featured%20Events/featured_events_cart.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Past%20Events/past_events_cart.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBanner.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBannerItem.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/QuickAccessItem/quick_access_item.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Volunteer%20Now%20Card/volunteer_now_card.dart';
import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(AssetsManager.logo),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            CustomText(
                              'Hello, Ahmad 👋',
                              color: ColorManager.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              'Cultural Center Member',
                              color: ColorManager.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined, size: 30),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        hint: 'Search events, centers, or libraries',
                        hintColor: ColorManager.lightGray,
                        filled: true,
                        fillColor: ColorManager.lightBackground,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorManager.gray,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusColor: ColorManager.deepGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CulturalSitesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: ColorManager.lightBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.public,
                          color: ColorManager.deepGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: AdBanner(
                  ads: [
                    AdBannerItem(
                      imageUrl:
                          'https://images.unsplash.com/photo-1452587925148-ce544e77e70d',
                      badgeText: 'SPECIAL EVENT',
                      title: 'Desert Photography Exhibition',
                      description: 'Capturing the beauty of our heritage',
                      dateText: 'Nov 12 • 6:00 PM',
                      locationText: 'National Art Center',
                    ),
                    AdBannerItem(
                      imageUrl:
                          'https://images.unsplash.com/photo-1452587925148-ce544e77e70d',
                      badgeText: 'WORKSHOP',
                      title: 'Pottery & Ceramics Workshop',
                      description: 'Hands-on session for all skill levels',
                      dateText: 'Nov 18 • 4:00 PM',
                      locationText: 'Heritage Library',
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: QuickAccessGrid()),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Featured Events',
                      color: ColorManager.deepGreen,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: CustomText(
                        'View All',
                        color: ColorManager.deepGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 340,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const FeaturedEventsCart();
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverList.separated(
                itemCount: 6,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return const PastEventsCart();
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: VolunteerNowCard()),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
