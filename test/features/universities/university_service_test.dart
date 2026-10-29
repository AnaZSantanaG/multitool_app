import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/universities/university_service.dart';

const sampleBody =
    '[{"state-province": null, "name": "Instituto Tecnologico de Las Americas", '
    '"web_pages": ["https://itla.edu.do/"], "alpha_two_code": "DO", '
    '"domains": ["itla.edu.do"], "country": "Dominican Republic"}]';

void main() {
  test('parses universities and encodes the country', () async {
    late Uri requested;
    final service = UniversityService(
      ApiClient(
        client: MockClient((request) async {
          requested = request.url;
          return http.Response(sampleBody, 200);
        }),
      ),
    );

    final result = await service.byCountry('Dominican Republic');

    expect(
      requested.toString(),
      'https://adamix.net/proxy.php?country=Dominican+Republic',
    );
    expect(result, hasLength(1));
    expect(result.single.name, 'Instituto Tecnologico de Las Americas');
    expect(result.single.domains, ['itla.edu.do']);
    expect(result.single.webPages, ['https://itla.edu.do/']);
  });

  test('returns an empty list when the country has no universities', () async {
    final service = UniversityService(
      ApiClient(client: MockClient((request) async => http.Response('[]', 200))),
    );

    final result = await service.byCountry('Atlantis');

    expect(result, isEmpty);
  });

  test('throws ApiException when the body is not a list', () async {
    final service = UniversityService(
      ApiClient(
        client: MockClient(
          (request) async => http.Response('{"error": "x"}', 200),
        ),
      ),
    );

    expect(() => service.byCountry('Peru'), throwsA(isA<ApiException>()));
  });
}
