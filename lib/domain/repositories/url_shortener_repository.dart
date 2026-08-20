import 'dart:math';

import '../../data/models/short_url_model.dart';

class UrlShortenerRepository {
  static const String _baseUrl = 'https://short.url/';
  static const String _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  final Random _random = Random();

  ShortUrlModel shorten(String url) {
    return ShortUrlModel(
      originalUrl: url,
      shortUrl: '$_baseUrl${_generateCode(6)}',
    );
  }

  String _generateCode(int length) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }
}