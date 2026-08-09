import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:directorateofculture/Helper/cach_helper.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';


class BookReaderScreen extends StatefulWidget {
  final int bookId;
  final String title;
  final String pdfUrl;

  const BookReaderScreen({
    super.key,
    required this.bookId,
    required this.title,
    required this.pdfUrl,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {  
  final PdfViewerController _pdfController = PdfViewerController();
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  bool _hasError = false;
  bool _isDownloading = false;

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  // نفس التوكن المستخدم في باقي الطلبات، لازم لأن مسار القراءة محمي في الباكند
  Map<String, String> get _authHeaders {
    final token = CacheHelper.getToken();
    return {
      if (token != null && token.toString().isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  void _goToPage() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          title: CustomText(
            'الانتقال إلى صفحة',
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '1 - $_totalPages',
              hintStyle: const TextStyle(color: Colors.white38),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                final page = int.tryParse(controller.text);
                if (page != null && page >= 1 && page <= _totalPages) {
                  _pdfController.jumpToPage(page);
                }
                Navigator.pop(context);
              },
              child: const Text('انتقال'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadFromReader() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final booksDir = Directory('${dir.path}/books');
      if (!await booksDir.exists()) {
        await booksDir.create(recursive: true);
      }
      final safeName = widget.title.trim().isEmpty
          ? 'book_${widget.bookId}'
          : widget.title.trim();
      final savePath = '${booksDir.path}/$safeName.pdf';

      await Dio().download(
        widget.pdfUrl,
        savePath,
        options: Options(headers: _authHeaders),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحميل "${widget.title}" بنجاح')),
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: SafeArea(
          child: Column(
            children: [
              // ─── الشريط العلوي الداكن ───
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CustomText(
                            widget.title,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          SizedBox(height: 2.h),
                          if (_totalPages > 0)
                            CustomText(
                              '$_currentPage / $_totalPages',
                              fontSize: 11.sp,
                              color: Colors.white60,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _isDownloading ? null : _downloadFromReader,
                      icon: _isDownloading
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // ─── صفحة القراءة (عارض PDF حقيقي) ───
              Expanded(
                child: _hasError
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.white54, size: 40.sp),
                              SizedBox(height: 10.h),
                              CustomText(
                                'تعذر تحميل الملف، تحقق من الاتصال بالإنترنت وحاول مرة أخرى',
                                color: Colors.white70,
                                fontSize: 13.sp,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 14.h),
                              TextButton(
                                onPressed: () => setState(() => _hasError = false),
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          SfPdfViewer.network(
                            widget.pdfUrl,
                            controller: _pdfController,
                            headers: _authHeaders,
                            canShowScrollHead: true,
                            canShowPaginationDialog: false,
                            onDocumentLoaded: (details) {
                              setState(() {
                                _isReady = true;
                                _totalPages = details.document.pages.count;
                                _currentPage = 1;
                              });
                            },
                            onDocumentLoadFailed: (details) {
                              setState(() {
                                _isReady = true;
                                _hasError = true;
                              });
                            },
                            onPageChanged: (details) {
                              setState(() => _currentPage = details.newPageNumber);
                            },
                          ),
                          if (!_isReady)
                            const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                        ],
                      ),
              ),

              // ─── الشريط السفلي الداكن (أدوات القراءة) ───
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ReaderToolButton(
                      icon: Icons.zoom_in_outlined,
                      label: 'تكبير',
                      onTap: _isReady && !_hasError
                          ? () => _pdfController.zoomLevel =
                              (_pdfController.zoomLevel + 0.25).clamp(1.0, 3.0)
                          : null,
                    ),
                    _ReaderToolButton(
                      icon: Icons.zoom_out_outlined,
                      label: 'تصغير',
                      onTap: _isReady && !_hasError
                          ? () => _pdfController.zoomLevel =
                              (_pdfController.zoomLevel - 0.25).clamp(1.0, 3.0)
                          : null,
                    ),
                    _ReaderToolButton(
                      icon: Icons.tag,
                      label: 'انتقال لصفحة',
                      onTap: _isReady && !_hasError && _totalPages > 0 ? _goToPage : null,
                    ),
                    _ReaderToolButton(
                      icon: Icons.download_outlined,
                      label: 'تحميل',
                      onTap: _isDownloading ? null : _downloadFromReader,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ReaderToolButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 18.sp,
              color: enabled ? Colors.white : Colors.white24,
            ),
          ),
          SizedBox(height: 6.h),
          CustomText(
            label,
            fontSize: 10.5.sp,
            color: enabled ? Colors.white70 : Colors.white24,
          ),
        ],
      ),
    );
  }
}