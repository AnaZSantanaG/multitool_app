import '../../core/api_client.dart';
import 'wp_post.dart';

class WpService {
  WpService(this._client, {this.host = 'egehid.gob.do'});

  final ApiClient _client;
  final String host;

  Future<List<WpPost>> latestPosts({int count = 3}) async {
    final uri = Uri.https(host, '/wp-json/wp/v2/posts', {
      'per_page': '$count',
      '_fields': 'title,excerpt,link',
    });
    final data = await _client.getJson(uri);
    if (data is! List) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return data
        .map<WpPost>((item) => WpPost.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
