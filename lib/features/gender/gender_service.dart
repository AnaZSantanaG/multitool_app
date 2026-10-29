import '../../core/api_client.dart';
import 'gender_result.dart';

class GenderService {
  GenderService(this._client);

  final ApiClient _client;

  Future<GenderResult> predict(String name) async {
    final uri = Uri.https('api.genderize.io', '/', {'name': name.trim()});
    final data = await _client.getJson(uri);
    if (data is! Map<String, dynamic>) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return GenderResult.fromJson(data);
  }
}
