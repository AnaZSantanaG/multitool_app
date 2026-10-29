import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/random_user/random_user_service.dart';

const sampleBody =
    '{"results":[{"name":{"title":"Mr","first":"Juan","last":"Perez"},'
    '"dob":{"date":"1964-03-24T07:48:38.774Z","age":62},'
    '"picture":{"large":"https://randomuser.me/api/portraits/men/1.jpg"}}],'
    '"info":{"results":1}}';

void main() {
  test('parses the first random user', () async {
    late Uri requested;
    final service = RandomUserService(
      ApiClient(
        client: MockClient((request) async {
          requested = request.url;
          return http.Response(sampleBody, 200);
        }),
      ),
    );

    final user = await service.fetch();

    expect(requested.toString(), 'https://randomuser.me/api/?results=1');
    expect(user.firstName, 'Juan');
    expect(user.lastName, 'Perez');
    expect(user.age, 62);
    expect(user.birthDateLabel, '24/03/1964');
    expect(user.pictureUrl, 'https://randomuser.me/api/portraits/men/1.jpg');
  });

  test('throws ApiException when results are empty', () async {
    final service = RandomUserService(
      ApiClient(
        client: MockClient(
          (request) async => http.Response('{"results":[]}', 200),
        ),
      ),
    );

    expect(() => service.fetch(), throwsA(isA<ApiException>()));
  });
}
