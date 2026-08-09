import 'dart:io';
import 'package:dio/dio.dart';
import 'package:directorateofculture/presentation/pages/Libraries/model/book_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/Helper/cach_helper.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استدعاءات الـ Cubit الخاصة بالتفاصيل (تأكد من مساراتك)
import 'package:directorateofculture/presentation/pages/Libraries/cubit/book_details_cubit.dart';
import 'package:directorateofculture/presentation/pages/Libraries/page/book_reader_screen.dart';

class BookDetailsScreen extends StatefulWidget {
  final int bookId; // نستقبل معرف الكتاب من الشاشة السابقة
  
  const BookDetailsScreen({super.key, required this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool _isBookmarked = false;
  bool _showFullDescription = false;
  final int _currentPageDot = 0;
  bool _isDownloading = false;
  double _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    // جلب تفاصيل الكتاب عند الدخول للشاشة
    context.read<BookDetailsCubit>().fetchBookDetails(widget.bookId);
  }

  Future<void> _downloadBook(BookModel book) async {
    if (book.pdfDownloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد ملف PDF لهذا الكتاب')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final booksDir = Directory('${dir.path}/books');
      if (!await booksDir.exists()) {
        await booksDir.create(recursive: true);
      }
      final safeName = book.title.trim().isEmpty ? 'book_${book.id}' : book.title.trim();
      final savePath = '${booksDir.path}/$safeName.pdf';

      final token = CacheHelper.getToken();
      await Dio().download(
        book.pdfDownloadUrl!,
        savePath,
        options: Options(headers: {
          if (token != null && token.toString().isNotEmpty) 'Authorization': 'Bearer $token',
        }),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      if (!mounted) return;

      // ⚠️ مجلد getApplicationDocumentsDirectory() خاص بالتطبيق وغير مرئي
      // للمستخدم بأي مدير ملفات على الهاتف. لضمان وصول الملف فعلياً لمساحة
      // المستخدم الحقيقية (تنزيلات/ملفات الجهاز)، نفتح صندوق المشاركة/الحفظ
      // الأصلي لنظام التشغيل مباشرة بعد اكتمال التحميل، ليختار المستخدم
      // "حفظ في الملفات" أو "التنزيلات" بنفسه.
      await Share.shareXFiles(
        [XFile(savePath, mimeType: 'application/pdf', name: '$safeName.pdf')],
        subject: book.title,
        text: 'اختر "حفظ في الملفات" لتنزيل الكتاب على جهازك.',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تجهيز "${book.title}"، اختر مكان الحفظ على جهازك')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تحميل الكتاب، حاول مرة أخرى')),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _openReader(BookModel book) {
    if (book.pdfReadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد ملف PDF لهذا الكتاب')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookReaderScreen(
          bookId: book.id,
          title: book.title,
          pdfUrl: book.pdfReadUrl!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.lightBackground,
        body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
          builder: (context, state) {
            if (state is BookDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookDetailsError) {
              return Center(child: Text('حدث خطأ: ${state.message}', style: const TextStyle(fontFamily: 'Cairo')));
            } else if (state is BookDetailsLoaded) {
              final book = state.book;
              
              return SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 100.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── غلاف الكتاب ───
                          Center(
                            child: Container(
                              width: 190.w,
                              height: 260.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorManager.black.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.network(
                                  book.coverUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: ColorManager.lightGray.withOpacity(0.3),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.menu_book_outlined,
                                        color: ColorManager.gray, size: 40.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // ─── مؤشر الصفحات (نقاط) ───
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              final isActive = index == _currentPageDot;
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: isActive ? 16.w : 6.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? ColorManager.darkForestGreen
                                      : ColorManager.lightGray,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 22.h),

                          // ─── العنوان والمؤلف ───
                          CustomText(
                            book.title,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.black,
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            book.author,
                            fontSize: 14.sp,
                            color: ColorManager.gray,
                          ),

                          SizedBox(height: 16.h),

                          // ─── الوسوم / معلومات الكتاب ───
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _InfoTag(
                                icon: Icons.category_outlined,
                                label: book.category,
                                filled: true,
                              ),
                              _InfoTag(
                                icon: Icons.description_outlined,
                                label: '${book.pagesCount} صفحة',
                              ),
                              _InfoTag(
                                icon: Icons.download_outlined,
                                label: book.fileSize,
                              ),
                              _InfoTag(
                                icon: Icons.language,
                                label: book.language,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // ─── الوصف ───
                          CustomText(
                            'الوصف',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.black,
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            book.description,
                            fontSize: 13.sp,
                            height: 1.7,
                            color: ColorManager.gray,
                            maxLines: _showFullDescription ? null : 3,
                            overflow: _showFullDescription
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () => setState(
                                () => _showFullDescription = !_showFullDescription),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  _showFullDescription ? 'عرض أقل' : 'عرض المزيد',
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.darkForestGreen,
                                ),
                                Icon(
                                  _showFullDescription
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 16.sp,
                                  color: ColorManager.darkForestGreen,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // ─── تاريخ الإضافة وعدد التحميلات ───
                          CustomContainer(
                            width: double.infinity,
                            color: ColorManager.titleWhite,
                            radius: 16.r,
                            paddingAll: 16,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        'تاريخ الإضافة',
                                        fontSize: 12.sp,
                                        color: ColorManager.gray,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        book.addedDate,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorManager.black,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1.w,
                                  height: 32.h,
                                  color: ColorManager.lightGray.withOpacity(0.4),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomText(
                                        'عدد التحميلات',
                                        fontSize: 12.sp,
                                        color: ColorManager.gray,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        '${book.downloadsCount}',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorManager.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── شريط علوي: رجوع + مشاركة + حفظ ───
                    Positioned(
                      top: 0.h,
                      left: 0.w,
                      right: 0.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CircleIconButton(
                              icon: Icons.arrow_back,
                              onTap: () => Navigator.maybePop(context),
                            ),
                            Row(
                              children: [
                                _CircleIconButton(
                                  icon: _isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  iconColor: _isBookmarked
                                      ? ColorManager.darkForestGreen
                                      : ColorManager.black,
                                  onTap: () => setState(
                                      () => _isBookmarked = !_isBookmarked),
                                ),
                                SizedBox(width: 8.w),
                                _CircleIconButton(
                                  icon: Icons.ios_share_outlined,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── أزرار أسفل الشاشة ───
                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      bottom: 0.h,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                        decoration: BoxDecoration(
                          color: ColorManager.lightBackground,
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: _isDownloading
                                    ? null
                                    : () => _downloadBook(book),
                                backgroundColor: ColorManager.titleWhite,
                                borderColor: ColorManager.darkForestGreen,
                                borderWidth: 1.2,
                                radius: 26.r,
                                fixedSize: Size(double.infinity, 52.h),
                                child: _isDownloading
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: ColorManager.darkForestGreen,
                                              value: _downloadProgress > 0
                                                  ? _downloadProgress
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          CustomText(
                                            _downloadProgress > 0
                                                ? '${(_downloadProgress * 100).toInt()}%'
                                                : 'جارِ التحميل...',
                                            color: ColorManager.darkForestGreen,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            'تحميل',
                                            color: ColorManager.darkForestGreen,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(width: 6.w),
                                          Icon(Icons.cloud_download_outlined,
                                              color: ColorManager.darkForestGreen,
                                              size: 16.sp),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () => _openReader(book),
                                backgroundColor: ColorManager.darkForestGreen,
                                radius: 26.r,
                                fixedSize: Size(double.infinity, 52.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      'قراءة الآن',
                                      color: ColorManager.titleWhite,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(width: 6.w),
                                    Icon(Icons.menu_book_outlined,
                                        color: ColorManager.titleWhite, size: 16.sp),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink(); // حالة ابتدائية
          },
        ),
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;

  const _InfoTag({
    required this.icon,
    required this.label,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: filled
          ? ColorManager.lightGreen.withOpacity(0.35)
          : ColorManager.titleWhite,
      radius: 10.r,
      paddingHorizontal: 12,
      paddingVertical: 8,
      borderColor: filled ? null : ColorManager.lightGray.withOpacity(0.4),
      borderWidth: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14.sp,
              color: filled
                  ? ColorManager.deepGreen
                  : ColorManager.gray),
          SizedBox(width: 6.w),
          CustomText(
            label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: filled ? ColorManager.deepGreen : ColorManager.black,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        width: 38.w,
        height: 38.h,
        color: ColorManager.titleWhite,
        shape: BoxShape.circle,
        alignment: Alignment.center,
        shadowColor: ColorManager.black.withOpacity(0.08),
        shadowBlurRadius: 6,
        child: Icon(icon, size: 18.sp, color: iconColor ?? ColorManager.black),
      ),
    );
  }
}