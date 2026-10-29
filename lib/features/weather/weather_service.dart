import '../../core/api_client.dart';
import 'cities.dart';
import 'weather_forecast.dart';

class WeatherService {
  WeatherService(this._client);

  final ApiClient _client;

  Future<WeatherForecast> today(City city) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${city.latitude}',
      'longitude': '${city.longitude}',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'America/Santo_Domingo',
      'forecast_days': '1',
    });
    final data = await _client.getJson(uri);
    if (data is! Map<String, dynamic> || data['daily'] is! Map) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return WeatherForecast.fromJson(data);
  }
}
