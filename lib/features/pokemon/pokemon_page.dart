import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/widgets/state_views.dart';
import 'pokemon.dart';
import 'pokemon_service.dart';

class PokemonPage extends StatefulWidget {
  PokemonPage({super.key, PokemonService? service})
      : service = service ?? PokemonService(ApiClient());

  final PokemonService service;

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController _controller = TextEditingController();
  Future<Pokemon>? _future;
  AudioPlayer? _player;

  @override
  void dispose() {
    _controller.dispose();
    _player?.dispose();
    super.dispose();
  }

  void _search() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _future = widget.service.byName(name);
    });
  }

  Future<void> _playCry(String url) async {
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(UrlSource(url));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo reproducir el sonido.')),
      );
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Pokémon',
                      hintText: 'pikachu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                  tooltip: 'Buscar',
                ),
              ],
            ),
          ),
          Expanded(child: _buildResult()),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final future = _future;
    if (future == null) {
      return const EmptyView(
        message: 'Escribe el nombre de un Pokémon, por ejemplo pikachu.',
      );
    }
    return FutureBuilder<Pokemon>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingView();
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: errorMessage(snapshot.error),
            onRetry: _search,
          );
        }
        final pokemon = snapshot.requireData;
        final imageUrl = pokemon.imageUrl;
        final cryUrl = pokemon.cryUrl;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.catching_pokemon, size: 120);
                },
              )
            else
              const Icon(Icons.catching_pokemon, size: 120),
            const SizedBox(height: 12),
            Text(
              _capitalize(pokemon.name),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Experiencia base'),
                subtitle: Text(
                  pokemon.baseExperience?.toString() ?? 'No disponible',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Habilidades', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final ability in pokemon.abilities)
                  Chip(label: Text(ability)),
              ],
            ),
            const SizedBox(height: 16),
            if (cryUrl != null)
              FilledButton.icon(
                onPressed: () => _playCry(cryUrl),
                icon: const Icon(Icons.volume_up),
                label: const Text('Reproducir sonido'),
              )
            else
              const Text(
                'Sonido no disponible.',
                textAlign: TextAlign.center,
              ),
          ],
        );
      },
    );
  }
}
