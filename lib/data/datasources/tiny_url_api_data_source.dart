import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/short_url_model.dart';

class TinyUrlApiDataSource {
  static const String _host = 'tinyurl.com';
  static const String _path = '/api-create.php';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  const TinyUrlApiDataSource(this._client);

  Future<ShortUrlModel> shorten(String originalUrl) async {
    final Uri requestUri = Uri.https(
      _host,
      _path,
      <String, String>{'url': originalUrl},
    );
    final http.Response response =
        await _client.get(requestUri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('TinyURL API gagal dengan status ${response.statusCode}');
    }
    final String shortUrl = response.body.trim();
    final Uri? parsed = Uri.tryParse(shortUrl);
    if (shortUrl.isEmpty ||
        parsed == null ||
        !parsed.hasScheme ||
        !parsed.host.contains('.')) {
      throw Exception('Respons TinyURL tidak valid');
    }
    return ShortUrlModel(
      originalUrl: originalUrl,
      shortUrl: shortUrl,
      createdAt: DateTime.now(),
    );
  }
}
