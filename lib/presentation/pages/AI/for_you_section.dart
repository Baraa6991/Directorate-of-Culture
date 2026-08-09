import 'package:directorateofculture/presentation/pages/AI/for_you_cubit.dart';
import 'package:directorateofculture/presentation/pages/AI/recommendation_model.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';


class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForYouCubit(repository: MiscRepository())..load(),
      child: const _ForYouView(),
    );
  }
}

class _ForYouView extends StatelessWidget {
  const _ForYouView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForYouCubit, ForYouState>(
      builder: (context, state) {
        // لا نعرض القسم إطلاقاً إذا ما فيه توصيات وما فيه تحميل (نتجنب فراغ مزعج بالواجهة)
        if (!state.isLoading &&
            state.recommendations.isEmpty &&
            state.errorMessage == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomText(
                  'قد يعجبك',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.darkForestGreen,
                ),
              ),
              SizedBox(height: 10.h),
              if (state.isLoading) _buildLoading(),
              if (!state.isLoading && state.errorMessage != null)
                _buildError(context, state.errorMessage!),
              if (!state.isLoading && state.recommendations.isNotEmpty)
                _buildList(state.recommendations),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 150.h,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomText(message, color: ColorManager.gray, fontSize: 13.sp),
          ),
          TextButton(
            onPressed: () => context.read<ForYouCubit>().load(refresh: true),
            child: CustomText('إعادة المحاولة', fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<RecommendationModel> recommendations) {
    return SizedBox(
      height: 190.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: recommendations.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) =>
            _RecommendationCard(recommendation: recommendations[index]),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;
  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final activity = recommendation.activity;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(activityId: activity.id),
          ),
        );
      },
      child: CustomContainer(
      width: 220.w,
      radius: 16.r,
      color: ColorManager.lightBackground,
      shadowColor: ColorManager.black.withOpacity(0.08),
      shadowBlurRadius: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: activity.image != null
                ? Image.network(
                    activity.image!,
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  activity.title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.darkForestGreen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  recommendation.reason,
                  fontSize: 11.sp,
                  color: ColorManager.gray,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 90.h,
      width: double.infinity,
      color: ColorManager.lightGreen.withOpacity(0.3),
      child: const Icon(Icons.event, color: ColorManager.mediumGreen),
    );
  }
}