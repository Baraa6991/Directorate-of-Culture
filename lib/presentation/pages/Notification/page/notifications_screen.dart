import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Notification/cubit/notifications_cubit.dart';
import 'package:directorateofculture/presentation/pages/Notification/cubit/notifications_state.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotificationsCubit(repository: MiscRepository())..loadFirstPage(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      context.read<NotificationsCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    // ✅ يُعلِّم كل الإشعارات كمقروءة عند مغادرة الشاشة (بالخروج فعلياً)،
    // فيختفي الرقم الأحمر على جرس الإشعارات بالرئيسية تلقائياً بعد العودة.
    context.read<NotificationsCubit>().markAllAsRead();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  IconData _iconFor(String? icon) {
    switch (icon) {
      case 'ticket':
        return Icons.confirmation_number_outlined;
      case 'star':
        return Icons.star_outline;
      case 'x-circle':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return DateFormat('d MMM', 'ar').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.black),
        title: CustomText(
          'الإشعارات',
          color: ColorManager.deepGreen,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    state.errorMessage!,
                    color: ColorManager.gray,
                    fontSize: 13.sp,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: cubit.loadFirstPage,
                    child: const CustomText('إعادة المحاولة', color: ColorManager.deepGreen),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none, size: 56.sp, color: ColorManager.lightGray),
                  SizedBox(height: 10.h),
                  CustomText('لا توجد إشعارات حتى الآن', color: ColorManager.gray, fontSize: 14.sp),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: cubit.loadFirstPage,
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: ColorManager.lightGray.withOpacity(0.3),
              ),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final n = state.items[index];

                return Dismissible(
                  key: ValueKey(n.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => cubit.delete(n.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () => cubit.markAsRead(n.id),
                    child: Container(
                      color: n.isRead
                          ? Colors.transparent
                          : ColorManager.lightGreen.withOpacity(0.12),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: ColorManager.deepGreen.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(_iconFor(n.icon), color: ColorManager.deepGreen, size: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        n.title,
                                        fontSize: 13.sp,
                                        fontWeight: n.isRead ? FontWeight.w500 : FontWeight.bold,
                                        color: ColorManager.black,
                                      ),
                                    ),
                                    if (!n.isRead)
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        margin: EdgeInsets.only(right: 4.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  n.body,
                                  fontSize: 12.sp,
                                  color: ColorManager.gray,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  _timeAgo(n.createdAt),
                                  fontSize: 10.sp,
                                  color: ColorManager.lightGray,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}