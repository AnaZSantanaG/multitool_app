class Pokemon {
  const Pokemon({
    required this.name,
    required this.baseExperience,
    required this.abilities,
    required this.imageUrl,
    required this.cryUrl,
  });

  final String name;
  final int? baseExperience;
  final List<String> abilities;
  final String? imageUrl;
  final String? cryUrl;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>? ?? const {};
    final other = sprites['other'] as Map<String, dynamic>? ?? const {};
    final artwork =
        other['official-artwork'] as Map<String, dynamic>? ?? const {};
    final cries = json['cries'] as Map<String, dynamic>? ?? const {};
    final abilities = (json['abilities'] as List? ?? const []).map((item) {
      final ability = (item as Map<String, dynamic>)['ability'];
      return (ability as Map<String, dynamic>)['name'] as String;
    }).toList();

    return Pokemon(
      name: json['name'] as String? ?? '',
      baseExperience: (json['base_experience'] as num?)?.toInt(),
      abilities: abilities,
      imageUrl: (artwork['front_default'] ?? sprites['front_default'])
          as String?,
      cryUrl: cries['latest'] as String?,
    );
  }
}
