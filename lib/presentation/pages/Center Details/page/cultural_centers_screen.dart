import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/center_details.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_center_card_model.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_centers_cubit.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cultural%20Sites/cultural_centers_state.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CulturalCentersScreen extends StatelessWidget {
  const CulturalCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CulturalCentersCubit(repository: HomeRepository())
            ..loadCenters(),
      child: const _CulturalCentersView(),
    );
  }
}

// ─────────────────────────────────────────────
class _CulturalCentersView extends StatefulWidget {
  const _CulturalCentersView();

  @override
  State<_CulturalCentersView> createState() => _CulturalCentersViewState();
}

class _CulturalCentersViewState extends State<_CulturalCentersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // ── AppBar ──
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: ColorManager.lightBackground,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: ColorManager.deepGreen,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      'المراكز الثقافية',
                      color: ColorManager.deepGreen,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                SizedBox(height: 22.h),
                // ── Search ──
                CustomTextfield(
                  controller: _searchController,
                  hint: 'ابحث عن مركز...',
                  hintColor: ColorManager.gray,
                  filled: true,
                  fillColor: ColorManager.lightBackground,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorManager.gray,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.r),
                    borderSide: BorderSide.none,
                  ),
                  focusColor: ColorManager.deepGreen,
                  onChanged: (value) =>
                      context.read<CulturalCentersCubit>().search(value),
                ),
                SizedBox(height: 18.h),
                // ── List ──
                Expanded(
                  child:
                      BlocBuilder<CulturalCentersCubit, CulturalCentersState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state.errorMessage != null) {
                            return Center(
                              child: CustomText(
                                state.errorMessage!,
                                color: ColorManager.gray,
                                fontSize: 14.sp,
                              ),
                            );
                          }
                          if (state.filteredCenters.isEmpty) {
                            return Center(
                              child: CustomText(
                                'لا توجد مراكز مطابقة للبحث',
                                color: ColorManager.gray,
                                fontSize: 14.sp,
                              ),
                            );
                          }

                          return GridView.builder(
                            padding: EdgeInsets.only(bottom: 20.h),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  mainAxisExtent:
                                      290, // أقل من قبل لأننا حذفنا الـ stats
                                ),
                            itemCount: state.filteredCenters.length,
                            itemBuilder: (context, index) {
                              final center = state
                                  .filteredCenters[index]; // ← أضف هذا السطر
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CenterDetails(centerId: center.id),
                                  ),
                                ),
                                child: _CenterCard(
                                  center: center,
                                  accentColor: index.isEven
                                      ? ColorManager.deepGreen
                                      : ColorManager.mediumGreen,
                                ),
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
class _CenterCard extends StatelessWidget {
  final CulturalCenterCardModel center;
  final Color accentColor;

  const _CenterCard({required this.center, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            SizedBox(
              height: 140.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _NetworkImage(url: center.imageUrl),
                  // gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.12),
                        ],
                      ),
                    ),
                  ),
                  // bookmark icon
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: ColorManager.titleWhite.withOpacity(0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        size: 16.sp,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Info ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  CustomText(
                    center.name,
                    color: ColorManager.deepGreen,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: ColorManager.mediumGreen,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: CustomText(
                          center.location,
                          color: ColorManager.gray,
                          fontSize: 11.sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Description
                  CustomText(
                    center.description,
                    color: ColorManager.gray,
                    fontSize: 11.sp,
                    maxLines: 3,
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
}

// ─────────────────────────────────────────────
/// Widget مستقل لتحميل صورة الشبكة مع fallback
class _NetworkImage extends StatelessWidget {
  final String url;
  const _NetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _fallback(),
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: ColorManager.lightBackground,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _fallback() => Container(
    color: ColorManager.lightBackground,
    child: Center(
      child: Icon(
        Icons.account_balance_outlined,
        color: ColorManager.deepGreen.withOpacity(0.45),
        size: 40.sp,
      ),
    ),
  );
}
