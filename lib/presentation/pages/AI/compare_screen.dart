import 'package:directorateofculture/presentation/pages/AI/comparison_cubit.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/AI/comparison_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';


class CompareScreen extends StatelessWidget {
  /// 'activity' أو 'center'
  final String type;
  final int id1;
  final String title1;
  final int id2;
  final String title2;

  const CompareScreen({
    super.key,
    required this.type,
    required this.id1,
    required this.title1,
    required this.id2,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComparisonCubit(repository: MiscRepository())
        ..compare(type: type, id1: id1, id2: id2),
      child: Scaffold(
        appBar: AppBar(title: const Text('المقارنة')),
        body: BlocBuilder<ComparisonCubit, ComparisonState>(
          builder: (context, state) {
            if (state is ComparisonLoading || state is ComparisonInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ComparisonError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: CustomText(
                    state.message,
                    color: ColorManager.gray,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final result = (state as ComparisonLoaded).result;
            return _buildContent(context, result);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ComparisonResultModel result) {
    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        _buildHeaderRow(),
        SizedBox(height: 16.h),
        _buildTable(result.criteria),
        SizedBox(height: 16.h),
        _buildVerdict(result.verdict),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            title1,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.darkForestGreen,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 40.w,
          child: CustomText(
            'مقابل',
            fontSize: 12.sp,
            color: ColorManager.gray,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: CustomText(
            title2,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.darkForestGreen,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<ComparisonCriterion> criteria) {
    return CustomContainer(
      radius: 14.r,
      color: ColorManager.lightBackground,
      paddingAll: 12,
      child: Column(
        children: criteria
            .map((c) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        c.label,
                        fontSize: 12.sp,
                        color: ColorManager.gray,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              c.item1,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorManager.darkForestGreen,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 40.w),
                          Expanded(
                            child: CustomText(
                              c.item2,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorManager.darkForestGreen,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      if (c != criteria.last)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Divider(color: ColorManager.lightGray, height: 1.h),
                        ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildVerdict(String verdict) {
    if (verdict.isEmpty) return const SizedBox.shrink();
    return CustomContainer(
      radius: 14.r,
      color: ColorManager.lightGreen.withOpacity(0.25),
      paddingAll: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: ColorManager.mediumGreen, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              verdict,
              fontSize: 13.sp,
              color: ColorManager.darkForestGreen,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
