class TermsCondition {
  final int id;
  final String value;
  final String createdAt;
  final String updatedAt;
  String hindiText;

  TermsCondition({
    required this.id,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.hindiText = '',
  });

  factory TermsCondition.fromJson(Map<String, dynamic> json) {
    return TermsCondition(
      id: json['id'],
      value: json['value'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      hindiText: json['translatedValue'] ?? '',
    );
  }
}