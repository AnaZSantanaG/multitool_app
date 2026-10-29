import '../../core/api_client.dart';
import 'pokemon.dart';

class PokemonService {
  PokemonService(this._client);

  final ApiClient _client;

  Future<Pokemon> byName(String name) async {
    final normalized = name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    final uri = Uri(
      scheme: 'https',
      host: 'pokeapi.co',
      pathSegments: ['api', 'v2', 'pokemon', normalized],
    );
    final Object? data;
    try {
      data = await _client.getJson(uri);
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        throw const ApiException('Pokémon no encontrado.', statusCode: 404);
      }
      rethrow;
    }
    if (data is! Map<String, dynamic>) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return Pokemon.fromJson(data);
  }
}
