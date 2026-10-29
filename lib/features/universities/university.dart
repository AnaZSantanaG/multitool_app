class University {
  const University({
    required this.name,
    required this.domains,
    required this.webPages,
  });

  final String name;
  final List<String> domains;
  final List<String> webPages;

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] as String? ?? 'Sin nombre',
      domains: List<String>.from(json['domains'] as List? ?? const []),
      webPages: List<String>.from(json['web_pages'] as List? ?? const []),
    );
  }
}
