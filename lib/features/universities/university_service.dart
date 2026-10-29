import '../../core/api_client.dart';
import 'university.dart';

class UniversityService {
  UniversityService(this._client);

  final ApiClient _client;

  Future<List<University>> byCountry(String country) async {
    final uri = Uri.https('adamix.net', '/proxy.php', {
      'country': country.trim(),
    });
    final data = await _client.getJson(uri);
    if (data is! List) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return data
        .map<University>((item) => University.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
