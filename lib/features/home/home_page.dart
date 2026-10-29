import 'package:flutter/material.dart';

import '../about/about_page.dart';
import '../gender/gender_page.dart';
import '../pokemon/pokemon_page.dart';
import '../random_user/random_user_page.dart';
import '../universities/universities_page.dart';
import '../weather/weather_page.dart';
import '../wordpress/wordpress_page.dart';

class ToolEntry {
  const ToolEntry({
    required this.title,
    required this.icon,
    required this.builder,
  });

  final String title;
  final IconData icon;
  final WidgetBuilder builder;
}

final List<ToolEntry> toolEntries = [
  ToolEntry(
    title: 'Predecir género',
    icon: Icons.wc,
    builder: (_) => GenderPage(),
  ),
  ToolEntry(
    title: 'Persona aleatoria',
    icon: Icons.person,
    builder: (_) => RandomUserPage(),
  ),
  ToolEntry(
    title: 'Universidades por país',
    icon: Icons.school,
    builder: (_) => UniversitiesPage(),
  ),
  ToolEntry(
    title: 'Clima en RD',
    icon: Icons.wb_sunny,
    builder: (_) => WeatherPage(),
  ),
  ToolEntry(
    title: 'Pokémon',
    icon: Icons.catching_pokemon,
    builder: (_) => PokemonPage(),
  ),
  ToolEntry(
    title: 'Noticias EGEHID',
    icon: Icons.newspaper,
    builder: (_) => WordPressPage(),
  ),
  ToolEntry(
    title: 'Acerca de',
    icon: Icons.info_outline,
    builder: (_) => const AboutPage(),
  ),
];

class HomePage extends StatelessWidget {
  HomePage({super.key, List<ToolEntry>? entries})
      : entries = entries ?? toolEntries;

  final List<ToolEntry> entries;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Caja de herramientas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/toolbox.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              semanticLabel: 'Foto de una caja de herramientas',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Hago varias cosas, Pruebame!',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          for (final entry in entries)
            Card(
              child: ListTile(
                leading: Icon(entry.icon),
                title: Text(entry.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: entry.builder),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
