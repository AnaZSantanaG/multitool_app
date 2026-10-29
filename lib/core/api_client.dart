import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

String errorMessage(Object? error) {
  if (error is ApiException) {
    return error.message;
  }
  return 'Ocurrió un error inesperado.';
}

class ApiClient {
  ApiClient({http.Client? client, this.timeout = const Duration(seconds: 10)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Future<dynamic> getJson(Uri uri) async {
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(timeout);
    } on TimeoutException {
      throw const ApiException(
        'La solicitud tardó demasiado. Intenta de nuevo.',
      );
    } on IOException {
      throw const ApiException('Sin conexión a internet.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor.');
    }

    if (response.statusCode != 200) {
      throw ApiException(
        _messageFor(response.statusCode),
        statusCode: response.statusCode,
      );
    }

    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
  }

  String _messageFor(int statusCode) {
    return switch (statusCode) {
      404 => 'No se encontró el recurso solicitado.',
      429 => 'Se alcanzó el límite de consultas. Intenta más tarde.',
      _ => 'Error del servidor (código $statusCode).',
    };
  }
}
