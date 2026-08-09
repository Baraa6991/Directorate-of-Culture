import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBannerItem.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitial());

  Future<void> loadHome() async {
    emit(HomeLoading());
    debugPrint('🔹 Loading home data...');

    try {
      final profile = await repository.getProfile();
      debugPrint(profile.toString());

      final ads = await repository.getAds();
      debugPrint(ads.toString());

      final profileData = profile;
      final adsData = ads;

      debugPrint('📨 Profile: $profileData');
      debugPrint('📨 Ads: $adsData');

      final user = profileData['user'] as Map<String, dynamic>?;
      final userName = (user?['name'] as String?)?.trim().isNotEmpty == true
          ? user!['name'] as String
          : 'مستخدم';
      final avatarUrl = user?['avatar'] as String?;

      final adsList = (adsData['data'] as List<dynamic>? ?? [])
          .map(
            (item) => AdBannerItem(
              imageUrl: item['image'] as String? ?? '',
              title: item['title'] as String? ?? '',
              description: item['description'] as String? ?? '',
            ),
          )
          .toList();

      emit(HomeLoaded(userName: userName, avatarUrl: avatarUrl, ads: adsList));
    } catch (e) {
      debugPrint('💥 Load home error: $e');
      emit(HomeError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
