import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/widgets/state_views.dart';
import 'cities.dart';
import 'weather_forecast.dart';
import 'weather_service.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({super.key, WeatherService? service})
      : service = service ?? WeatherService(ApiClient());

  final WeatherService service;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  City _city = cities.first;
  late Future<WeatherForecast> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.today(_city);
  }

  void _select(City? city) {
    if (city == null) {
      return;
    }
    setState(() {
      _city = city;
      _future = widget.service.today(city);
    });
  }

  void _reload() {
    setState(() {
      _future = widget.service.today(_city);
    });
  }

  IconData _iconFor(int code) {
    if (code == 0 || code == 1) {
      return Icons.wb_sunny;
    }
    if (code == 2 || code == 3) {
      return Icons.cloud;
    }
    if (code == 45 || code == 48) {
      return Icons.cloud_queue;
    }
    if (code >= 95) {
      return Icons.thunderstorm;
    }
    if (code >= 51) {
      return Icons.water_drop;
    }
    return Icons.help_outline;
  }

  String _formatTemp(double? value) {
    return value == null ? '--' : '${value.round()}°C';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownMenu<City>(
            initialSelection: _city,
            label: const Text('Ciudad'),
            expandedInsets: EdgeInsets.zero,
            onSelected: _select,
            dropdownMenuEntries: [
              for (final city in cities)
                DropdownMenuEntry<City>(value: city, label: city.name),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<WeatherForecast>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingView();
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: errorMessage(snapshot.error),
                  onRetry: _reload,
                );
              }
              final forecast = snapshot.requireData;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Hoy, ${forecast.dateLabel}', style: textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Icon(
                        _iconFor(forecast.weatherCode),
                        size: 96,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(forecast.description, style: textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text('Máxima'),
                              Text(
                                _formatTemp(forecast.maxTemp),
                                style: textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Mínima'),
                              Text(
                                _formatTemp(forecast.minTemp),
                                style: textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Probabilidad de lluvia: ${forecast.rainProbability?.toString() ?? '--'}%',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
