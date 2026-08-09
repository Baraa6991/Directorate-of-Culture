import 'dart:async';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استدعاءات الـ Cubit والـ Model (تأكد من صحة مساراتك)
import 'package:directorateofculture/presentation/pages/Libraries/cubit/books_list_cubit.dart';
import 'package:directorateofculture/presentation/pages/Libraries/cubit/books_list_state.dart';
import 'package:directorateofculture/presentation/pages/Libraries/cubit/book_details_cubit.dart';
import 'package:directorateofculture/presentation/pages/Libraries/model/book_model.dart';
import 'package:directorateofculture/presentation/pages/Libraries/page/book_details_screen.dart';

class BooksListScreen extends StatefulWidget {
  const BooksListScreen({super.key});

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // جلب الكتب عند فتح الشاشة
    context.read<BooksListCubit>().fetchBooks();

    // مراقبة التمرير للأسفل لجلب المزيد من الكتب (Pagination)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<BooksListCubit>().fetchMoreBooks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.lightBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // ─── العنوان + زر مكتبتي ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'الكتب',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                    CustomContainer(
                      color: ColorManager.lightBackground,
                      borderColor: ColorManager.lightGray.withOpacity(0.5),
                      borderWidth: 1,
                      radius: 20.r,
                      paddingHorizontal: 14,
                      paddingVertical: 8,
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 16.sp,
                            color: ColorManager.darkForestGreen,
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            'مكتبتي',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.darkForestGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // ─── حقل البحث ───
                CustomTextfield(
                  controller: _searchController,
                  hint: 'ابحث عن كتاب أو مؤلف...',
                  hintColor: ColorManager.lightGray,
                  textAlign: TextAlign.right,
                  filled: true,
                  fillColor: ColorManager.titleWhite,
                  suffixIcon: Icon(Icons.search, color: ColorManager.gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: ColorManager.lightGray.withOpacity(0.4),
                    ),
                  ),
                  focusColor: ColorManager.deepGreen,
                  onChanged: (value) {
                    // Debounce: منستنى المستخدم يوقف عن الكتابة 500ms قبل ما نبعت الطلب
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      context.read<BooksListCubit>().search(value);
                    });
                  },
                  onSubmitted: (value) {
                    _debounce?.cancel();
                    context.read<BooksListCubit>().search(value);
                  },
                ),

                SizedBox(height: 14.h),

                // ─── تصنيفات الكتب (قادمة فعلياً من الباك اند) ───
                BlocBuilder<BooksListCubit, BooksListState>(
                  builder: (context, state) {
                    String selectedCategory = 'الكل';
                    List<String> backendCategories = const [];
                    if (state is BooksListLoaded) {
                      selectedCategory = state.selectedCategory;
                      backendCategories = state.categories;
                    }
                    final categories = ['الكل', ...backendCategories];

                    if (categories.length <= 1) {
                      // ما وصلت التصنيفات بعد (أول تحميل) أو ما في تصنيفات إطلاقاً
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      height: 36.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == selectedCategory;
                          return GestureDetector(
                            onTap: () {
                              // عند الضغط، نجلب الكتب حسب التصنيف الجديد
                              context.read<BooksListCubit>().fetchBooks(
                                category: category,
                              );
                            },
                            child: CustomContainer(
                              color: isSelected
                                  ? ColorManager.darkForestGreen
                                  : ColorManager.titleWhite,
                              radius: 20.r,
                              paddingHorizontal: 16,
                              alignment: Alignment.center,
                              borderColor: isSelected
                                  ? null
                                  : ColorManager.lightGray.withOpacity(0.4),
                              borderWidth: 1,
                              child: CustomText(
                                category,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? ColorManager.titleWhite
                                    : ColorManager.gray,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                SizedBox(height: 18.h),

                // ─── شبكة الكتب (مربوطة بالباك إند) ───
                Expanded(
                  child: BlocBuilder<BooksListCubit, BooksListState>(
                    builder: (context, state) {
                      if (state is BooksListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BooksListError) {
                        return Center(child: Text('حدث خطأ: ${state.message}'));
                      } else if (state is BooksListLoaded) {
                        if (state.books.isEmpty) {
                          final message = state.searchQuery.trim().isNotEmpty
                              ? 'لا توجد نتائج لـ "${state.searchQuery}"'
                              : 'لا توجد كتب في هذا التصنيف';
                          return Center(
                            child: Text(
                              message,
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                          );
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 20.h),
                          // زيادة العدد بمقدار 1 لإظهار مؤشر التحميل في الأسفل إن وجد
                          itemCount:
                              state.books.length +
                              (state.isFetchingMore ? 1 : 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 14.w,
                                childAspectRatio: 0.62,
                              ),
                          itemBuilder: (context, index) {
                            if (index < state.books.length) {
                              final book = state.books[index];
                              return GestureDetector(
                                onTap: () {
                                  // نمرر نفس الـ repository المستخدم أصلاً في BooksListCubit
                                  // حتى BookDetailsCubit يلاقي مصدر بياناته بدون أي إعداد إضافي
                                  final repository =
                                      context.read<BooksListCubit>().repository;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider<BookDetailsCubit>(
                                        create: (_) => BookDetailsCubit(repository),
                                        child: BookDetailsScreen(
                                          bookId: book.id,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: _BookGridItem(book: book),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      }
                      return const SizedBox.shrink();
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

class _BookGridItem extends StatelessWidget {
  final BookModel book;

  const _BookGridItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.network(
                  book.coverUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: ColorManager.lightGray.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: ColorManager.gray,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8.h,
                left: 8.w,
                child: CustomContainer(
                  width: 26.w,
                  height: 26.h,
                  // يمكنك لاحقاً ربط isDownloaded بقاعدة بيانات محلية لتغيير اللون
                  color: ColorManager.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.cloud_download_outlined,
                    color: ColorManager.titleWhite,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CustomText(
          book.title,
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.black,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        CustomText(
          book.author,
          fontSize: 11.5.sp,
          color: ColorManager.gray,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}