class GenderResult {
  const GenderResult({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  final String name;
  final String? gender;
  final double probability;
  final int count;

  bool get isMale => gender == 'male';
  bool get hasPrediction => gender != null;

  factory GenderResult.fromJson(Map<String, dynamic> json) {
    return GenderResult(
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String?,
      probability: (json['probability'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
