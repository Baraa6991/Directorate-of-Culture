part of 'home_cubit.dart';



abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String userName;
  final String? avatarUrl;
  final List<AdBannerItem> ads;

  HomeLoaded({
    required this.userName,
    required this.avatarUrl,
    required this.ads,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}