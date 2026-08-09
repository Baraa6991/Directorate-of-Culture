class BookModel {
  final int id;
  final String title;
  final String author;
  final String category;
  final String coverUrl;
  final String description;
  final int pagesCount;
  final String fileSize;
  final String language;
  final String? pdfReadUrl;
  final String? pdfDownloadUrl;
  final int downloadsCount;
  final String addedDate;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.coverUrl,
    required this.description,
    required this.pagesCount,
    required this.fileSize,
    required this.language,
    required this.pdfReadUrl,
    required this.pdfDownloadUrl,
    required this.downloadsCount,
    required this.addedDate,
  });

  bool get hasFile => pdfReadUrl != null && pdfReadUrl!.isNotEmpty;

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      category: json['category'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pagesCount: int.tryParse(json['pages_count']?.toString() ?? '') ?? 0,
      fileSize: json['file_size'] as String? ?? '',
      language: json['language'] as String? ?? 'العربية',
      pdfReadUrl: json['pdf_read_url'] as String?,
      pdfDownloadUrl: json['pdf_download_url'] as String?,
      downloadsCount: int.tryParse(json['downloads_count']?.toString() ?? '') ?? 0,
      addedDate: json['added_date'] as String? ?? '',
    );
  }
}