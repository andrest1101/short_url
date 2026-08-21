import 'dart:math';

import '../models/short_url_model.dart';

class MockUrlDataSource {
  static const String _baseUrl = 'https://short.url/';
  static const String _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static const int _codeLength = 6;

  final Random _random = Random();

  ShortUrlModel generateShortUrl(String originalUrl) {
    return ShortUrlModel(
      originalUrl: originalUrl,
      shortUrl: '$_baseUrl${_generateCode(_codeLength)}',
    );
  }

  String _generateCode(int length) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }
}
