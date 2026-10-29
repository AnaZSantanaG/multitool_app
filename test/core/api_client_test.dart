import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';

void main() {
  final uri = Uri.parse('https://com.anasantana20242153.multitool_app/data');

  test('returns the decoded json on 200', () async {
    final client = ApiClient(
      client: MockClient((request) async => http.Response('{"ok": true}', 200)),
    );

    final data = await client.getJson(uri);

    expect(data, {'ok': true});
  });

  test('throws ApiException with the status code on 404', () async {
    final client = ApiClient(
      client: MockClient((request) async => http.Response('missing', 404)),
    );

    expect(
      () => client.getJson(uri),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('throws ApiException on timeout', () async {
    final client = ApiClient(
      timeout: const Duration(milliseconds: 5),
      client: MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return http.Response('{}', 200);
      }),
    );

    expect(() => client.getJson(uri), throwsA(isA<ApiException>()));
  });

  test('throws ApiException when the network fails', () async {
    final client = ApiClient(
      client: MockClient((request) async => throw const SocketException('x')),
    );

    expect(
      () => client.getJson(uri),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Sin conexión a internet.',
        ),
      ),
    );
  });

  test('throws ApiException when the body is not json', () async {
    final client = ApiClient(
      client: MockClient((request) async => http.Response('not json', 200)),
    );

    expect(() => client.getJson(uri), throwsA(isA<ApiException>()));
  });
}
