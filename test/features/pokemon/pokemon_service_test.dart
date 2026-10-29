import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/pokemon/pokemon_service.dart';

const sampleBody =
    '{"name":"pikachu","base_experience":112,'
    '"abilities":[{"ability":{"name":"static"}},{"ability":{"name":"lightning-rod"}}],'
    '"sprites":{"front_default":"https://img.test/front.png",'
    '"other":{"official-artwork":{"front_default":"https://img.test/art.png"}}},'
    '"cries":{"latest":"https://audio.test/latest.ogg","legacy":"https://audio.test/legacy.ogg"}}';

void main() {
  test('parses a pokemon and normalizes the name', () async {
    late Uri requested;
    final service = PokemonService(
      ApiClient(
        client: MockClient((request) async {
          requested = request.url;
          return http.Response(sampleBody, 200);
        }),
      ),
    );

    final pokemon = await service.byName('  Pikachu ');

    expect(requested.toString(), 'https://pokeapi.co/api/v2/pokemon/pikachu');
    expect(pokemon.name, 'pikachu');
    expect(pokemon.baseExperience, 112);
    expect(pokemon.abilities, ['static', 'lightning-rod']);
    expect(pokemon.imageUrl, 'https://img.test/art.png');
    expect(pokemon.cryUrl, 'https://audio.test/latest.ogg');
  });

  test('falls back to the default sprite and handles missing cries', () async {
    final service = PokemonService(
      ApiClient(
        client: MockClient(
          (request) async => http.Response(
            '{"name":"x","abilities":[],"sprites":{"front_default":"https://img.test/f.png"}}',
            200,
          ),
        ),
      ),
    );

    final pokemon = await service.byName('x');

    expect(pokemon.imageUrl, 'https://img.test/f.png');
    expect(pokemon.cryUrl, isNull);
    expect(pokemon.baseExperience, isNull);
  });

  test('throws a readable message on 404', () async {
    final service = PokemonService(
      ApiClient(
        client: MockClient((request) async => http.Response('Not Found', 404)),
      ),
    );

    expect(
      () => service.byName('nope'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Pokémon no encontrado.',
        ),
      ),
    );
  });
}
