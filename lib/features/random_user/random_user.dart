class RandomUser {
  const RandomUser({
    required this.firstName,
    required this.lastName,
    required this.pictureUrl,
    required this.birthDate,
    required this.age,
  });

  final String firstName;
  final String lastName;
  final String pictureUrl;
  final DateTime birthDate;
  final int age;

  String get birthDateLabel {
    final date = birthDate.toUtc();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  factory RandomUser.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final picture = json['picture'] as Map<String, dynamic>;
    final dob = json['dob'] as Map<String, dynamic>;
    return RandomUser(
      firstName: name['first'] as String? ?? '',
      lastName: name['last'] as String? ?? '',
      pictureUrl: picture['large'] as String? ?? '',
      birthDate: DateTime.parse(dob['date'] as String),
      age: (dob['age'] as num).toInt(),
    );
  }
}
