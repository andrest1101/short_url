import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/short_url_model.dart';

class UrlLocalDataSource {
  static const String _historyKey = 'url_history';

  final SharedPreferences _prefs;

  const UrlLocalDataSource(this._prefs);

  List<ShortUrlModel> loadHistory() {
    return _readStored().reversed.toList();
  }

  Future<void> addUrl(ShortUrlModel model) async {
    final List<Map<String, dynamic>> history = [
      ..._readStored().map((ShortUrlModel item) => item.toJson()),
      model.toJson(),
    ];
    await _prefs.setString(_historyKey, jsonEncode(history));
  }

  Future<void> deleteUrl(String shortUrl) async {
    final List<Map<String, dynamic>> history = _readStored()
        .where((ShortUrlModel item) => item.shortUrl != shortUrl)
        .map((ShortUrlModel item) => item.toJson())
        .toList();
    await _prefs.setString(_historyKey, jsonEncode(history));
  }

  List<ShortUrlModel> _readStored() {
    final String? raw = _prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (dynamic item) =>
                ShortUrlModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
