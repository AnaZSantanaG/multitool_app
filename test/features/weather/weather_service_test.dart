import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/weather/cities.dart';
import 'package:multitool_app/features/weather/weather_forecast.dart';
import 'package:multitool_app/features/weather/weather_service.dart';

const sampleBody =
    '{"daily":{"time":["2026-10-27"],"weather_code":[61],'
    '"temperature_2m_max":[31.4],"temperature_2m_min":[24.1],'
    '"precipitation_probability_max":[70]}}';

void main() {
  test('parses the daily forecast and sends the city coordinates', () async {
    late Uri requested;
    final service = WeatherService(
      ApiClient(
        client: MockClient((request) async {
          requested = request.url;
          return http.Response(sampleBody, 200);
        }),
      ),
    );

    final forecast = await service.today(cities.first);

    expect(requested.host, 'api.open-meteo.com');
    expect(requested.queryParameters['latitude'], '18.4861');
    expect(requested.queryParameters['timezone'], 'America/Santo_Domingo');
    expect(forecast.dateLabel, '27/10/2026');
    expect(forecast.description, 'Lluvia ligera');
    expect(forecast.maxTemp, 31.4);
    expect(forecast.minTemp, 24.1);
    expect(forecast.rainProbability, 70);
  });

  test('unknown weather codes have a fallback description', () {
    expect(describeWeatherCode(999), 'Condición desconocida');
    expect(describeWeatherCode(0), 'Despejado');
  });

  test('throws ApiException when daily data is missing', () async {
    final service = WeatherService(
      ApiClient(client: MockClient((request) async => http.Response('{}', 200))),
    );

    expect(() => service.today(cities.first), throwsA(isA<ApiException>()));
  });
}
