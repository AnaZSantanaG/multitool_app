String describeWeatherCode(int code) {
  return switch (code) {
    0 => 'Despejado',
    1 => 'Mayormente despejado',
    2 => 'Parcialmente nublado',
    3 => 'Nublado',
    45 || 48 => 'Niebla',
    51 || 53 || 55 => 'Llovizna',
    56 || 57 => 'Llovizna helada',
    61 => 'Lluvia ligera',
    63 => 'Lluvia moderada',
    65 => 'Lluvia fuerte',
    66 || 67 => 'Lluvia helada',
    80 => 'Chubascos ligeros',
    81 => 'Chubascos moderados',
    82 => 'Chubascos fuertes',
    95 => 'Tormenta eléctrica',
    96 || 99 => 'Tormenta con granizo',
    _ => 'Condición desconocida',
  };
}

class WeatherForecast {
  const WeatherForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.rainProbability,
  });

  final String date;
  final int weatherCode;
  final double? maxTemp;
  final double? minTemp;
  final int? rainProbability;

  String get description => describeWeatherCode(weatherCode);

  String get dateLabel {
    final parts = date.split('-');
    if (parts.length != 3) {
      return date;
    }
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;

    num? first(String key) {
      final values = daily[key] as List?;
      if (values == null || values.isEmpty) {
        return null;
      }
      return values.first as num?;
    }

    return WeatherForecast(
      date: (daily['time'] as List).first as String,
      weatherCode: first('weather_code')?.toInt() ?? -1,
      maxTemp: first('temperature_2m_max')?.toDouble(),
      minTemp: first('temperature_2m_min')?.toDouble(),
      rainProbability: first('precipitation_probability_max')?.toInt(),
    );
  }
}
