import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/wordpress/wp_post.dart';
import 'package:multitool_app/features/wordpress/wp_service.dart';

const sampleBody =
    '[{"title":{"rendered":"Noticia &#8211; Uno"},'
    '"excerpt":{"rendered":"<p>Resumen &hellip; largo</p>\\n"},'
    '"link":"https://egehid.gob.do/noticia-uno/"}]';

void main() {
  test('cleanHtml removes tags and decodes entities', () {
    expect(cleanHtml('<p>Hola &amp; <b>adios</b></p>\n'), 'Hola & adios');
  });

  test('parses posts and requests three items', () async {
    late Uri requested;
    final service = WpService(
      ApiClient(
        client: MockClient((request) async {
          requested = request.url;
          return http.Response(sampleBody, 200);
        }),
      ),
    );

    final posts = await service.latestPosts();

    expect(requested.host, 'egehid.gob.do');
    expect(requested.path, '/wp-json/wp/v2/posts');
    expect(requested.queryParameters['per_page'], '3');
    expect(posts, hasLength(1));
    expect(posts.single.title, 'Noticia – Uno');
    expect(posts.single.excerpt, 'Resumen … largo');
    expect(posts.single.link, 'https://egehid.gob.do/noticia-uno/');
  });

  test('throws ApiException when the endpoint is blocked', () async {
    final service = WpService(
      ApiClient(client: MockClient((request) async => http.Response('', 401))),
    );

    expect(() => service.latestPosts(), throwsA(isA<ApiException>()));
  });
}
