import 'package:html/parser.dart' as html_parser;

String cleanHtml(String source) {
  final text = html_parser.parse(source).documentElement?.text ?? '';
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

class WpPost {
  const WpPost({
    required this.title,
    required this.excerpt,
    required this.link,
  });

  final String title;
  final String excerpt;
  final String link;

  factory WpPost.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>?;
    final excerpt = json['excerpt'] as Map<String, dynamic>?;
    return WpPost(
      title: cleanHtml(title?['rendered'] as String? ?? ''),
      excerpt: cleanHtml(excerpt?['rendered'] as String? ?? ''),
      link: json['link'] as String? ?? '',
    );
  }
}
