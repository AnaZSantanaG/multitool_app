import '../../core/api_client.dart';
import 'random_user.dart';

class RandomUserService {
  RandomUserService(this._client);

  final ApiClient _client;

  Future<RandomUser> fetch() async {
    final uri = Uri.https('randomuser.me', '/api/', {'results': '1'});
    final data = await _client.getJson(uri);
    final results = data is Map<String, dynamic> ? data['results'] : null;
    if (results is! List || results.isEmpty) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    return RandomUser.fromJson(results.first as Map<String, dynamic>);
  }
}
