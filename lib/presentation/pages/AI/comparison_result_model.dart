class ComparisonCriterion {
  final String label;
  final String item1;
  final String item2;

  ComparisonCriterion({
    required this.label,
    required this.item1,
    required this.item2,
  });

  factory ComparisonCriterion.fromJson(Map<String, dynamic> json) {
    return ComparisonCriterion(
      label: json['label'] as String? ?? '',
      item1: json['item_1']?.toString() ?? '-',
      item2: json['item_2']?.toString() ?? '-',
    );
  }
}

class ComparisonResultModel {
  final List<ComparisonCriterion> criteria;
  final String verdict;

  ComparisonResultModel({required this.criteria, required this.verdict});

  factory ComparisonResultModel.fromJson(Map<String, dynamic> json) {
    return ComparisonResultModel(
      criteria: (json['criteria'] as List<dynamic>? ?? [])
          .map((e) => ComparisonCriterion.fromJson(e as Map<String, dynamic>))
          .toList(),
      verdict: json['verdict'] as String? ?? '',
    );
  }
}
